//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import AuthenticationServices
import Foundation

@available(iOS 13.0, *)
public enum AppleLoginUseCaseError: Error {
    case cancelled
    case loginFailed(ASAuthorizationError)
    case parsingFailed(Error)
    case unknown(Error)
}

// MARK: - Object Lifecycle

@available(iOS 13.0, *)
extension AppleLoginUseCaseError {

    public init(_ error: Error) {
        switch error {
        case let error as AppleLoginUseCaseError:
            self = error
        default:
            self = .unknown(error)
        }
    }
}

// MARK: - Localization

@available(iOS 13.0, *)
extension AppleLoginUseCaseError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .cancelled:
            return "The user canceled the authorization attempt"
        case let .parsingFailed(error):
            return "Parsing failed with error: \(error.localizedDescription)"
        case let .loginFailed(error):
            return "Login failed with error: \(error.localizedDescription)"
        case let .unknown(error):
            return error.localizedDescription
        }
    }
}
