//
//  NetworkRequest.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/28/22.
//

import Foundation

struct NetworkRequest {
    func sendRequest(to urlString: String, withData data: Data?, withHeaders headers: [String : String]?, usingMethod method: String, withCompletion completion: @escaping (Result<Data, Error>) -> Void) {
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
