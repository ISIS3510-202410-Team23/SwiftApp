//
//  AuthService.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation
import FirebaseAuth
import SwiftUI
import LocalAuthentication


// Kept here to maintain auth models together

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    let name: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
        self.name = user.displayName
    }
}


class AuthService {
    static let shared = AuthService()
    private init () {}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}

// MARK: SIGN IN SSO
extension AuthService {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Local Authentication with biometrics
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock to access content") { success, error in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        print("Authentication failed: \(error?.localizedDescription ?? "Unknown error")")
                        completion(false)
                    }
                }
            }
        } else {
            print("Biometric authentication unavailable")
            completion(false)
        }
    }
    
    
}

