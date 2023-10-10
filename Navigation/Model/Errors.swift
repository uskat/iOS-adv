//
//  AuthError.swift
//  Navigation
//
//  Created by Diego Abramoff on 05.10.23.
//

import Foundation

enum AuthError: Error {
    case unhandledError(description: String)
    case passNotFound(description: String)
    case unableRetrievePass
    
    var debugDescription: String {
        switch self {
        case .unhandledError(let description):
            return "Unhandled Error: \(description)"
        case .passNotFound(let description):
            return "Pass not found. Error: \(description)"
        case .unableRetrievePass:
            return "Unable to retrieve login and pass from data"
        }
    }
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
