//
//  Zen.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/28/22.
//

import UIKit

struct Zen {
    static var shared = Zen()
    private let apiURL = "https://api.zenmoney.ru/v8/diff/"
    private let clientID = "gf538d3b09035dbd6e3b37b50055ab"
    private let clienSecret = "c8a832f0fd"
    private let redirectURI = "cs://oauthcallback"
    private let authURL = "https://api.zenmoney.ru/oauth2/authorize/"
    private let requestTokenURL = "https://api.zenmoney.ru/oauth2/token/"
    private let networkRequest = NetworkRequest()
    public var isLoggedIn: Bool {
        !Token.shared.accessToken.isEmpty
    }
    
    func auth() {
        guard let url = URL(string: authURL + "?response_type=code&client_id=\(clientID)&redirect_uri=\(redirectURI)") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func logout() {
        do {
            try Token.shared.removeToken()
        } catch {
            print("Error logging out: \(error)")
        }
    }
    
    func getDiff(withCompletion completion: @escaping (Result<DiffResponse, Error>) -> Void) {
        guard isLoggedIn else { return }
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let lastSyncTimestamp = UserDefaults.standard.integer(forKey: "lastSyncTimeStamp")
        let diff = DiffRequest(currentClientTimestamp: currentTimestamp, serverTimestamp: lastSyncTimestamp)
        
        do {
            let encoder = JSONEncoder()
            let diffData = try encoder.encode(diff)
            
            networkRequest.sendRequest(to: apiURL, withData: diffData, withHeaders: ["Content-Type": "application/json", "Authorization": "Bearer \(Token.shared.accessToken)"], usingMethod: "POST") { result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(DiffResponse.self, from: data)
                        completion(.success(decodedData))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            return
        }
    }
    
    func handleOauthRedirect(url: URL?, withCompletion completion: (() -> Void)?) {
        guard let unwrappedURL = url else { return }
        let urlString = "\(unwrappedURL)"
        if let regex = try? NSRegularExpression(pattern: "[a-zA-Z0-9]{30}") {
            let results = regex.matches(in: urlString, range: NSRange(urlString.startIndex..., in: urlString))
            let token = results.map { String(urlString[Range($0.range, in: urlString)!]) }.first!
            let dataString = "grant_type=authorization_code&client_id=\(clientID)&client_secret=\(clienSecret)&code=\(token)&redirect_uri=\(redirectURI)"
            let dataStringEncoded = dataString.data(using: .utf8)
            
            networkRequest.sendRequest(to: requestTokenURL, withData: dataStringEncoded, withHeaders: ["Content-Type": "application/x-www-form-urlencoded"], usingMethod: "POST") { result in
                switch result {
                case .success(let data):
                    do {
                        try Token.shared.upsertToken(from: data)
//                        try Token.shared.upsertToken(data, identifier: "accessToken")
                    } catch {
                        print("Error upserting token: \(error)")
                    }
                case .failure(let error):
                    print("Error getting auth response: \(error)")
                }
            }
        }
    }
}
