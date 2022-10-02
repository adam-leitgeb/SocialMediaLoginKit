//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import Combine
import Foundation
import GoogleSignIn
import UIKit

@available(iOS 13.0, *)
public final class GoogleLoginUseCaseMock: GoogleLoginUseCase {

    // MARK: - Object Lifecycle

    public init() {
    }

    // MARK: - Actions

    public func authenticate() -> AnyPublisher<any GIDGoogleUserProtocol, GoogleLoginUseCaseError> {
        let arbitrary = MockGIDGoogleUser.arbitrary()
        return Just(arbitrary)
            .mapError(GoogleLoginUseCaseError.init)
            .eraseToAnyPublisher()
    }
}
