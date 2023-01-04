//
//  AuthResponse.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/28/22.
//

import Foundation

struct AuthResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}
