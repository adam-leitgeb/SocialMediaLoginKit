//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import Combine
import FBSDKLoginKit
import Foundation

@available(iOS 13.0, *)
public final class ProductionFacebookLoginUseCase: FacebookLoginUseCase {

    // MARK: - Types

    private enum Permission: String, CaseIterable {
        case email
        case userFriends = "user_friends"
    }

    // MARK: - Object Lifecycle

    public init(appID: String) {
        Settings.shared.appID = appID
    }

    // MARK: - Actions

    public func authenticate() -> AnyPublisher<AccessToken, FacebookLoginUseCaseError> {
        Future<AccessToken, FacebookLoginUseCaseError> { promise in
            if let accessToken = AccessToken.current {
                return promise(.success(accessToken))
            }

            let permissions: [Permission] = [.email, .userFriends]

            LoginManager().logIn(permissions: permissions.map(\.rawValue), from: nil) { result, error in
                if let result = result, let token = result.token, !result.isCancelled {
                    promise(.success(token))
                } else if let result = result, result.isCancelled {
                    promise(.failure(.cancelled))
                } else if let error = error {
                    promise(.failure(.error(error.localizedDescription)))
                } else {
                    promise(.failure(.error("Ambiguous state")))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func loadProfile() -> AnyPublisher<Profile, FacebookLoginUseCaseError> {
        Future<Profile, FacebookLoginUseCaseError> { promise in
            Profile.loadCurrentProfile { profile, error in
                if let profile = profile {
                    promise(.success(profile))
                } else if let error = error {
                    promise(.failure(.error(error.localizedDescription)))
                } else {
                    promise(.failure(.error("Ambiguous state")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

