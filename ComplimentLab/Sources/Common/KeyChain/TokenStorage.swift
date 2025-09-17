//
//  TokenStorege.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/5/25.
//

import Foundation
import Security

struct Token: Codable {
    var accessToken: String?
    var refreshToken: String?
}

final class KeychainStorage {
    
    static let shared = KeychainStorage()
    
    private init() {}
    
    private(set) static var cachedToken: Token?
    
    enum Key: String {
        case service = "com.raven.complimentlab"
        case token = "userToken"
    }
}

// MARK: - JWT 토큰 관리
extension KeychainStorage {
    func saveToken(_ tokens: Data?) {
        guard let tokens else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Key.service.rawValue,
            kSecAttrAccount as String: Key.token.rawValue,
            kSecValueData as String: tokens
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess,
              let token = try? JSONDecoder().decode(Token.self, from: tokens) else {
            return
        }
                
        Self.cachedToken = token
    }
    
    func getToken() -> Token? {
        if let token = Self.cachedToken {
            return token
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Key.service.rawValue,
            kSecAttrAccount as String: Key.token.rawValue,
            kSecReturnData as String: true  
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data,
              let token = try? JSONDecoder().decode(Token.self, from: data) else {
            return nil
        }
        Self.cachedToken = token
        print(#function, #line, "토큰 : \(token)" )
        return token
    }
    
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Key.service.rawValue,
            kSecAttrAccount as String: Key.token.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }

    func hasToken() -> Bool {
        return getToken() != nil
    }
    
    func reissueToken(accessToken: String) {
        Self.cachedToken?.accessToken = accessToken
        guard let tokenData = try? JSONEncoder().encode(Self.cachedToken) else { return }
        self.saveToken(tokenData)
    }
}
