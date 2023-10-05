//
//  AuthError.swift
//  Navigation
//
//  Created by Diego Abramoff on 05.10.23.
//

import Foundation

enum AuthError: Error {
    case unableGetLogin(description: String)
    case loginNotFound(description: String)
    case unableRetrieveLogin
    
    var debugDescription: String {
        switch self {
        case .unableGetLogin(let description):
            return "Unable to get login. Error: \(description)"
        case .loginNotFound(let description):
            return "Login not found. Error: \(description)"
        case .unableRetrieveLogin:
            return "Unable to retrieve login from data"
        }
    }
}


