//
//  KeychainService.swift
//  Navigation
//
//  Created by Diego Abramoff on 04.10.23.
//

import Foundation
import Security

class KeychainService {
    
    //UserDeafaults Key
    private var isLoginExist = "isLoginExist"
    
    private var credentials = Credentials(pass: "")
    private let userDefaults = UserDefaults.standard
    static let shared = KeychainService()

    private init() {}
    
    func getLogin(completion: @escaping (Result<String, AuthError>) -> Void)  {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.service,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query, &extractedData)
        guard status == errSecItemNotFound || status == errSecSuccess else {            completion(.failure(.unableGetLogin(description: String(status))))
            return
        }

        guard status != errSecItemNotFound else {
            completion(.failure(.loginNotFound(description: String(status))))
            return
        }
        
        guard let loginData = extractedData as? Data,
              let login = String(data: loginData, encoding: .utf8) else {
            completion(.failure(.unableRetrieveLogin))
            return
        }
        completion(.success(login))
    }
    
    func saveLogin(fromField login: String?) {
        guard let loginData = login?.data(using: .utf8) else {
            print("Unable to retrieve data from password")
            return
        }
        
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: loginData,
            kSecAttrService: credentials.service
        ] as [CFString : Any] as CFDictionary
        
        let status = SecItemAdd(attributes, nil)
        guard status == errSecDuplicateItem || status == errSecSuccess else {
            print("Unable to add login. Error = \(status)")
            userDefaults.set(false, forKey: isLoginExist)
            return
        }
        print("New login successfully added.")
        userDefaults.set(true, forKey: isLoginExist)
    }
}
