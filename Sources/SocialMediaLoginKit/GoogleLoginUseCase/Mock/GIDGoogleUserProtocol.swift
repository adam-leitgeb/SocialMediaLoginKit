//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import Foundation
import GoogleSignIn

public protocol GIDGoogleUserProtocol {
    associatedtype Authentication: GIDAuthenticationProtocol
    var authentication: Authentication { get }
}

public protocol GIDAuthenticationProtocol {
    var idToken: String? { get }
}

// MARK: - Utilities

extension GIDGoogleUser: GIDGoogleUserProtocol {
}

extension GIDAuthentication: GIDAuthenticationProtocol {
}

