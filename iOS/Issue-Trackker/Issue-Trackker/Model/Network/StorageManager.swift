//
//  KeyChain.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/21.
//

import Foundation
import Security

struct User: Codable {
    var token: String
}

class StorageManager {
    
    static let shared = StorageManager()
    private let account = "issue-trackker"
    private let service = "github"
    
    private init() {}
    
    func createUser(_ user: User) -> Bool {
        
        guard let data = try? JSONEncoder().encode(user) else {
            return false
        }
        
        let query: [CFString:Any] = [kSecClass: kSecClassGenericPassword,
                                     kSecAttrService: service,
                                     kSecAttrAccount: account,
                                     kSecValueData: data]

        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func readUser() -> User? {
        let query: [CFString:Any] = [kSecClass: kSecClassGenericPassword,
                                     kSecAttrService: service,
                                     kSecAttrAccount: account,
                                     kSecMatchLimit: kSecMatchLimitOne,
                                     kSecReturnAttributes: true,
                                     kSecReturnData: true]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            return nil
        }

        guard let existingItem = item as? [CFString: Any],
              let data = existingItem[kSecValueData] as? Data,
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        
        return user
    }
    
    func updateUser(_ user: String) -> Bool {
            guard let data = try? JSONEncoder().encode(user) else {
            return false
        }
        
        let query: [CFString:Any] = [kSecClass: kSecClassGenericPassword,
                                     kSecAttrService: service,
                                     kSecAttrAccount: account]
        
        let attributes: [CFString: Any] = [kSecAttrAccount: account,
                                           kSecAttrGeneric: data]
        
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
    }
    
    func deleteUser() -> Bool {
        let query: [CFString:Any] = [kSecClass: kSecClassGenericPassword,
                                     kSecAttrService: service,
                                     kSecAttrAccount: account]
        
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
