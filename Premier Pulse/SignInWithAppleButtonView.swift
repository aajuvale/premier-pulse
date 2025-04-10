//
//  SignInWithAppleButtonView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/25/24.
//


import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    handleAuthorization(authorization)
                case .failure(let error):
                    print("Authorization failed: \(error.localizedDescription)")
                }
            }
        )
        .signInWithAppleButtonStyle(.black) // Choose style as .black, .white, or .whiteOutline
        .frame(height: 50)
        .cornerRadius(8)
    }

    private func handleAuthorization(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            // Store user identifier for future app launches
            UserDefaults.standard.set(userIdentifier, forKey: "appleUserIdentifier")

            print("User ID: \(userIdentifier)")
            if let name = fullName {
                print("Full Name: \(name)")
            }
            if let email = email {
                print("Email: \(email)")
            }
        }
    }
}
