//
//  Token.swift
//  Cash Stash
//
//  Created by Dmitriy on 10/28/22.
//

import UIKit

//Data(tokenString.utf8)

class Token {
    static let shared = Token() //singleton
    static let service = "com.dmitriynikulin.Cash-Stash"
    
    var accessToken: String {
        do {
            return try getData(with: "accessToken") ?? ""
        } catch {
            return ""
        }
    }
        
    enum KeychainError: LocalizedError {
        case itemNotFound
        case duplicateItem
        case unexpectedStatus(OSStatus)
    }
    
    func saveData(with dataString: String, identifier: String) throws {
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Token.service,
            kSecAttrAccount: identifier,
            kSecValueData: dataString.data(using: .utf8)!
        ] as CFDictionary
        
        let status = SecItemAdd(attributes, nil)
        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                throw KeychainError.duplicateItem
            }
            throw KeychainError.unexpectedStatus(status)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CS.tokenUpdated"), object: nil)
    }
    
    func updateData(with dataString: String, identifier: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Token.service,
            kSecAttrAccount: identifier
        ] as CFDictionary
        
        let attributes = [
            kSecValueData: dataString.data(using: .utf8)
        ] as CFDictionary
        
        let status = SecItemUpdate(query, attributes)
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            }
            throw KeychainError.unexpectedStatus(status)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CS.tokenUpdated"), object: nil)
    }
    
    func getData(with identifier: String) throws -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Token.service,
            kSecAttrAccount: identifier,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess else {
            return nil
//            if status == errSecItemNotFound {
//                // Technically could make the return optional and return nil here
//                // depending on how you like this to be taken care of
//                throw KeychainError.itemNotFound
//            }
//            throw KeychainError.unexpectedStatus(status)
        }
        // Lots of bang operators here, due to the nature of Keychain functionality.
        // You could work with more guards/if let or others.
        
//        let data = result as! AuthResponse
//        print(data.accessToken)
        return String(data: result as! Data, encoding: .utf8)!
    }
    
    func removeData(with identifier: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Token.service,
            kSecAttrAccount: identifier
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
        
    func upsertToken(from data: Data) throws {
        let responseData = try JSONDecoder().decode(AuthResponse.self, from: data)
        do {
            try updateData(with: responseData.accessToken, identifier: "accessToken")
            try updateData(with: "\(responseData.expiresIn)", identifier: "expiresIn")
            try updateData(with: responseData.refreshToken, identifier: "refreshToken")
            try updateData(with: responseData.tokenType, identifier: "tokenType")

        } catch KeychainError.itemNotFound {
            try saveData(with: responseData.accessToken, identifier: "accessToken")
            try saveData(with: "\(responseData.expiresIn)", identifier: "expiresIn")
            try saveData(with: responseData.refreshToken, identifier: "refreshToken")
            try saveData(with: responseData.tokenType, identifier: "tokenType")
        }
    }
    
    func removeToken() throws {
        do {
            try removeData(with: "accessToken")
            try removeData(with: "expiresIn")
            try removeData(with: "refreshToken")
            try removeData(with: "tokenType")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CS.tokenUpdated"), object: nil)
        } catch {
            print("Error removing token: \(error)")
        }
    }
}

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
