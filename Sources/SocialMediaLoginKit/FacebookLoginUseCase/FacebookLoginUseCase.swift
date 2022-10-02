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
public protocol FacebookLoginUseCase {
    func authenticate() -> AnyPublisher<AccessToken, FacebookLoginUseCaseError>
    func loadProfile() -> AnyPublisher<Profile, FacebookLoginUseCaseError>
}
