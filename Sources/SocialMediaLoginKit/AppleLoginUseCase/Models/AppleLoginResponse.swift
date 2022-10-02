//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import AuthenticationServices
import Foundation

@available(iOS 13.0, *)
public struct AppleLoginResponse {

    // MARK: - Properties

    public let token: String
    public let userID: String
    public var email: String?
    public var firstName: String?
    public var lastName: String?
}

// MARK: - Object Lifecycle

@available(iOS 13.0, *)
extension AppleLoginResponse {

    public init(authorization: ASAuthorization) throws {
        let appleIDCredential = try Self.parseAppleIDCredential(from: authorization.credential)
        token = try Self.parseAppleIDToken(from: appleIDCredential)
        userID = appleIDCredential.user
        email = appleIDCredential.email
        firstName = appleIDCredential.fullName?.givenName
        lastName = appleIDCredential.fullName?.familyName
    }

    // Helpers

    private static func parseAppleIDCredential(from credential: ASAuthorizationCredential) throws -> ASAuthorizationAppleIDCredential {
        guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential else {
            throw AppleLoginUseCaseError.parsingFailed("ASAuthorizationAppleIDCredential not found")
        }
        return appleIDCredential
    }

    private static func parseAppleIDToken(from credential: ASAuthorizationAppleIDCredential) throws -> String {
        guard let appleIDToken = credential.identityToken else {
            throw AppleLoginUseCaseError.parsingFailed("Token not found")
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw AppleLoginUseCaseError.parsingFailed(appleIDToken.debugDescription)
        }
        return idTokenString
    }
}

