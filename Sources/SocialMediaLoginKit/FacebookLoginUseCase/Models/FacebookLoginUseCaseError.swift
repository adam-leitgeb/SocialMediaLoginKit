//
//  FacebookLoginUseCaseError.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import Foundation

@available(iOS 13.0, *)
public enum FacebookLoginUseCaseError: Error {
    case cancelled
    case error(Error)
}

// MARK: - Localization

@available(iOS 13.0, *)
extension FacebookLoginUseCaseError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case let .error(error):
            return error.localizedDescription
        case .cancelled:
            return nil
        }
    }
}
