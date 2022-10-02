//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import AuthenticationServices
import Combine
import Foundation

@available(iOS 13.0, *)
public protocol AppleLoginUseCase {
    func authenticate() -> AnyPublisher<AppleLoginResponse, AppleLoginUseCaseError>
}
