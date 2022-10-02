//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import Combine
import Foundation
import GoogleSignIn

@available(iOS 13.0, *)
public protocol GoogleLoginUseCase {
    func authenticate() -> AnyPublisher<any GIDGoogleUserProtocol, GoogleLoginUseCaseError>
}

