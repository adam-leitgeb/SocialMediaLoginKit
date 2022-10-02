//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import Foundation
import SwiftKeychainWrapper

extension KeychainWrapper {

    public enum Keys {

        // Apple Login

        public static let email = KeychainWrapper.Key(rawValue: "AppleLoginUseCaseProduction.email")
        public static let firstName = KeychainWrapper.Key(rawValue: "LoginWithAppleUseCaseProduction.firstName")
        public static let lastName = KeychainWrapper.Key(rawValue: "LoginWithAppleUseCaseProduction.lastName")

        // Fymo Login

        public static let accessToken = KeychainWrapper.Key(rawValue: "UserDefaults.Keys.accessToken")
        public static let secretToken = KeychainWrapper.Key(rawValue: "UserDefaults.Key.secretToken")
    }
}

