//
//  ZenTests.swift
//  Cash_StashTests
//
//  Created by Dmitriy on 1/9/23.
//

import XCTest
@testable import Cash_Stash

class ZenTests: XCTestCase {
    var zen: Zen!
    let clientID = "gf538d3b09035dbd6e3b37b50055ab"
    let clienSecret = "c8a832f0fd"
    let redirectURI = "cs://oauthcallback"
    let requestTokenURL = "https://api.zenmoney.ru/oauth2/token/"
    
    override func setUp() {
        super.setUp()
        zen = Zen()
    }
    
    override func tearDown() {
        zen = nil
        super.tearDown()
    }
    
    class MockUIApplication: UIApplication {
        var openURLs: [URL] = []
        override func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
            openURLs.append(url)
        }
    }
    func testAuth() {
        let expectedURLString = "https://api.zenmoney.ru/oauth2/authorize/?response_type=code&client_id=gf538d3b09035dbd6e3b37b50055ab&redirect_uri=cs://oauthcallback"
        let url = URL(string: expectedURLString)
        XCTAssertNotNil(url)
    }
    
    func testLogout() {
        let expectation = XCTestExpectation(description: "Remove token from keychain")
        do {
            try Token.shared.removeToken()
        } catch {
            XCTFail("Error logging out: \(error)")
        }
        expectation.fulfill()
    }

    
    func testGetDiff() {
        let expectation = XCTestExpectation(description: "Fetch diff from server")
        
        Zen.shared.getDiff { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                XCTFail("Error fetching diff: \(error)")
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testHandleOauthRedirect() {
        // Test that the function returns early if the `url` argument is `nil`.
        let expectation1 = XCTestExpectation(description: "HandleOauth returns nil")
        mockHandleOauthRedirect(url: nil, withCompletion: nil, expectation: expectation1)
        // Test that the function correctly extracts the token from the `url` argument using the regular expression.
        let expectation2 = XCTestExpectation(description: "HandleOauth works fine")
        let url = URL(string: "https://api.zenmoney.ru/oauth2/authorize/?response_type=code&client_id=gf538d3b09035dbd6e3b37b50055ab&redirect_uri=cs://oauthcallback")!
        mockHandleOauthRedirect(url: url, withCompletion: nil, expectation: expectation2)
    }
    
    func testSendRequest() {
        let expectation = XCTestExpectation(description: "HandleOauthRedirect works fine")
        let dataString = "grant_type=authorization_code&client_id=\(clientID)&client_secret=\(clienSecret)&code&redirect_uri=\(redirectURI)"
        let dataStringEncoded = dataString.data(using: .utf8)
        mockSendRequest(to: requestTokenURL, withData: dataStringEncoded, withHeaders: ["Content-Type": "application/x-www-form-urlencoded"], usingMethod: "POST") { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(let error):
                print("Error getting auth response: \(error)")
            }
        }
    }
    
    func mockHandleOauthRedirect(url: URL?, withCompletion completion: (() -> Void)?, expectation: XCTestExpectation) {
        guard let unwrappedURL = url else { return }
        let urlString = "\(unwrappedURL)"
        if let regex = try? NSRegularExpression(pattern: "[a-zA-Z0-9]{30}") {
            let results = regex.matches(in: urlString, range: NSRange(urlString.startIndex..., in: urlString))
            let token = results.map { String(urlString[Range($0.range, in: urlString)!]) }.first!
            let dataString = "grant_type=authorization_code&client_id=\(clientID)&client_secret=\(clienSecret)&code=\(token)&redirect_uri=\(redirectURI)"
            let dataStringEncoded = dataString.data(using: .utf8)
            
            mockSendRequest(to: requestTokenURL, withData: dataStringEncoded, withHeaders: ["Content-Type": "application/x-www-form-urlencoded"], usingMethod: "POST") { result in
                switch result {
                case .success(_):
                    if expectation.accessibilityTextualContext?.rawValue ?? "HandleOauth works fine" == "HandleOauth works fine" {
                        expectation.fulfill()
                    } else {
                        XCTFail("Error, should fail")
                    }
                case .failure(_):
                    if expectation.accessibilityTextualContext?.rawValue ?? "HandleOauth works fine" == "HandleOauth works fine" {
                        XCTFail("Error, should work fine")
                    } else {
                        expectation.fulfill()
                    }
                    
                }
            }
        }
    }
    
    func mockSendRequest(to urlString: String, withData data: Data?, withHeaders headers: [String : String]?, usingMethod method: String, withCompletion completion: @escaping (Result<Data, Error>) -> Void) {
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        guard let url = URL(string: encodedURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let headers = headers, !headers.isEmpty {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        request.httpBody = data
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let normalResponse = response as? HTTPURLResponse, (400...600).contains(normalResponse.statusCode) {
                completion(.failure(NetworkError().returnError(rawValue: normalResponse.statusCode)))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(error!))
            }
        }.resume()
    }
}
