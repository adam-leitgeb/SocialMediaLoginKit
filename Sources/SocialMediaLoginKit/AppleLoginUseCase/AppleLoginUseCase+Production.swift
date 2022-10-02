//
//  File.swift
//  
//
//  Created by Adam Leitgeb on 02.10.22.
//

import AuthenticationServices
import Combine
import Foundation
import SwiftKeychainWrapper

@available(iOS 13.0, *)
public final class AppleLoginUseCaseProduction: NSObject, AppleLoginUseCase {

    // MARK: - Properties

    private var publisher: PassthroughSubject<AppleLoginResponse, AppleLoginUseCaseError>? = nil

    // MARK: - Actions

    public func authenticate() -> AnyPublisher<AppleLoginResponse, AppleLoginUseCaseError> {
        publisher?.send(completion: .failure(.cancelled))
        publisher = PassthroughSubject<AppleLoginResponse, AppleLoginUseCaseError>()

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()

        return publisher!.eraseToAnyPublisher()
    }
}

// MARK: - ASAuthorizationControllerDelegate

@available(iOS 13.0, *)
extension AppleLoginUseCaseProduction: ASAuthorizationControllerDelegate {

    // In the simulator, you can test Sign in with Apple many times as you want, and you would get everything (fullName,
    // email, user, and identityToken) return in authorizationController(controller: ASAuthorizationController,
    // didCompleteWithAuthorization authorization: ASAuthorization), but when you test on real device, this won't be the
    // case.

    // If you test this on a device, once you grant the permission (on any devices or simulator with the same Apple ID),
    // the subsequence sign in would prompt the user with this dialog instead.
    // = Tap Continue would result in a call on success delegate method, BUT full name and email won't be returned
    //   in `ASAuthorization`.

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        do {
            var response = try AppleLoginResponse(authorization: authorization)
            // The first "Sign in with Apple" returns users name and email. If user logs out, or removes the app, the
            // "Sign in with Apple" won't return these data ever again. That's why we need to store them in Keychain.
            // Unlike UserDefailts, data stored in Keychain survives application's removal.
            storeEmailAndNameIntoKeychainIfPresent(response)
            response = loadNameAndEmailFromKeychainIfMissing(response)
            publisher?.send(response)
        } catch {
            let loginWithAppleError = AppleLoginUseCaseError(error)
            publisher?.send(completion: .failure(loginWithAppleError))
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else {
            publisher?.send(completion: .failure(.unknown(error)))
            return
        }

        switch error.code {
        case .unknown:
            // If the device has no Apple ID, `ASAuthorizationErrorUnknown` is called.
            break
        case .canceled:
            publisher?.send(completion: .failure(.cancelled))
        default:
            let error: AppleLoginUseCaseError = .loginFailed(error)
            publisher?.send(completion: .failure(error))
        }
    }

    // Helpers

    private func storeEmailAndNameIntoKeychainIfPresent(_ response: AppleLoginResponse) {
        _ = response.firstName.flatMap { KeychainWrapper.standard.set($0, forKey: KeychainWrapper.Keys.firstName.rawValue) }
        _ = response.lastName.flatMap { KeychainWrapper.standard.set($0, forKey: KeychainWrapper.Keys.lastName.rawValue) }
        _ = response.email.flatMap { KeychainWrapper.standard.set($0, forKey: KeychainWrapper.Keys.email.rawValue) }
    }

    // TODO: - Store the information in Keychain - data in UserDefaults won't survive app removal.
    private func loadNameAndEmailFromKeychainIfMissing(_ response: AppleLoginResponse) -> AppleLoginResponse {
        var mutableResponse = response

        if response.firstName == nil {
            let firstName = KeychainWrapper.standard.string(forKey: KeychainWrapper.Keys.firstName)
            mutableResponse.firstName = firstName
        }

        if response.lastName == nil {
            let lastName = KeychainWrapper.standard.string(forKey: KeychainWrapper.Keys.lastName)
            mutableResponse.lastName = lastName
        }

        if response.email == nil {
            let email = KeychainWrapper.standard.string(forKey: KeychainWrapper.Keys.email)
            mutableResponse.email = email
        }

        return mutableResponse
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

@available(iOS 13.0, *)
extension AppleLoginUseCaseProduction: ASAuthorizationControllerPresentationContextProviding {

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        return windowScene.windows[0]
    }
}

