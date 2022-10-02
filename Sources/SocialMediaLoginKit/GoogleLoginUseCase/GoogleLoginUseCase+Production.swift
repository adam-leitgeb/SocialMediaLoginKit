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
public final class GoogleLoginUseCaseProduction: NSObject, GoogleLoginUseCase {

    // MARK: - Properties

    private let googleOAuthClientId: String

    // Helpers

    private var rootViewController: UIViewController {
        UIApplication.shared.connectedScenes.first
            .flatMap { $0 as? UIWindowScene }
            .flatMap { $0.windows.first }
            .flatMap { $0.rootViewController }
        ?? UIViewController()
    }

    // MARK: - Object Lifecycle

    public init(googleOAuthClientId: String) {
        self.googleOAuthClientId = googleOAuthClientId
    }

    // MARK: - Actions

    public func authenticate() -> AnyPublisher<any GIDGoogleUserProtocol, GoogleLoginUseCaseError> {
        Future<any GIDGoogleUserProtocol, GoogleLoginUseCaseError> { [unowned self] promise in
            let configuration = GIDConfiguration(clientID: self.googleOAuthClientId)
            GIDSignIn.sharedInstance.signIn(
                with: configuration,
                presenting: self.rootViewController
            ) { user, error in
                if let error = error.flatMap(GoogleLoginUseCaseError.init) {
                    promise(.failure(error))
                } else if let user = user {
                    promise(.success(user))
                } else {
                    promise(.failure(.error("Ambiguous state")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

