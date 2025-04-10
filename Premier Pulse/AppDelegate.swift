//
//  AppDelegate.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/25/24.
//
import UIKit
import AuthenticationServices

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Perform additional setup after app launch
        return true
    }

    private func performExistingAccountSetupFlows() {
        let requests = [ASAuthorizationAppleIDProvider().createRequest()]
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            // Handle the authorized userIdentifier accordingly
            let provider = ASAuthorizationAppleIDProvider()
            provider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // The user is authorized
                    print("User is authorized")
                case .revoked, .notFound:
                    // Credentials revoked or not found
                    print("Credentials are not valid")
                default:
                    break
                }
            }
            print("User is authorized with user ID: \(userIdentifier)")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed with error: \(error.localizedDescription)")
    }
}
