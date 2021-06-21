//
//  KeyChain.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/21.
//

import Foundation
import Security

class StorageManager {
    
    static let shared = StorageManager()
    private let account = "Issue-Trackker"
    private let service = Bundle.main.bundleIdentifier
    private lazy var query: [CFString:Any]? = {
        guard let service = self.service else {
            return nil
        }
        return [kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account]
    }()
    
    private init() {}
    
    func createUser(_ user: String) -> Bool {
        guard let data = try? JSONEncoder().encode(user),
              let service = self.service else {
            return false
        }
        
        let query: [CFString:Any] = [kSecClass: kSecClassGenericPassword,
                                     kSecAttrService: service,
                                     kSecAttrAccount: account,
                                     kSecAttrGeneric: data]
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func readUser(_ user: String) -> String? {
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
              let data = existingItem[kSecAttrGeneric] as? Data,
              let user = try? JSONDecoder().decode(String.self, from: data) else {
            return nil
        }
        return user
    }
    
    func updateUser(_ user: String) -> Bool {
        guard let query = self.query,
              let data = try? JSONEncoder().encode(user) else {
            return false
        }
        
        let attributes: [CFString: Any] = [kSecAttrAccount: account,
                                           kSecAttrGeneric: data]
        
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
    }
    
    func deleteUser() -> Bool {
        guard let query = self.query else {
            return false
        }
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
