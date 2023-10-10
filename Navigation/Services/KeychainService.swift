//
//  KeychainService.swift
//  Navigation
//
//  Created by Diego Abramoff on 04.10.23.
//

import Foundation
import Security

class KeychainService {
    
    var credentials = Credentials(login: "", pass: "")
    private let userDefaults = UserDefaults.standard
    static let shared = KeychainService()

    private init() {}
    
    func getLogin(completion: @escaping (Result<Credentials, AuthError>) -> Void) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.service,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query, &item)
        
        guard status != errSecItemNotFound else {
            completion(.failure(.passNotFound(description: String(status))))
            throw KeychainError.noPassword
        }
        
        guard status == errSecSuccess else {
            completion(.failure(.unhandledError(description: String(status))))
            throw KeychainError.unhandledError(status: status)
        }

        guard let existingItem = item as? [String: Any],
              let passData = existingItem[kSecValueData as String] as? Data,
              let pass = String(data: passData, encoding: .utf8),
              let login = existingItem[kSecAttrAccount as String] as? String
        else {
            completion(.failure(.unableRetrievePass))
            throw KeychainError.unexpectedPasswordData
        }
        
        credentials.login = login
        credentials.pass = pass
        completion(.success(credentials))
        print("🟢 Login and pass successfully retreived from Keychain")
    }
    
    func saveToKeichain() throws {
        guard let credentialsPass = credentials.pass.data(using: .utf8) else {
            print("Keychain. Unable to retrieve data from password")
            return
        }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: credentials.login,
            kSecValueData: credentialsPass,
            kSecAttrService: credentials.service
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        guard status == errSecDuplicateItem || status == errSecSuccess else {
            print("Keychain. Unable to add login and pass. Error = \(status)")
            userDefaults.set(false, forKey: isPassExist)
            throw KeychainError.unhandledError(status: status)
        }

        print("🟢 New login and pass successfully added to Keychain.")
        userDefaults.set(true, forKey: isPassExist)
    }
    
    func deleteDataFromKeychain() throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: credentials.login,
            kSecAttrService: credentials.service,
            kSecReturnData: false
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecItemNotFound || status == errSecSuccess else {
            print("Keychain. Unable to delete login and pass. Error = \(status)")
            userDefaults.set(false, forKey: isPassExist)
            throw KeychainError.unhandledError(status: status)
        }

        print("🟢 Login and pass successfully deleted from Keychain.")
        userDefaults.set(false, forKey: isPassExist)
    }
}
