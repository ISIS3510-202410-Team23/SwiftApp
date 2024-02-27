//
//  LoginViewModel.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation

@MainActor
@Observable final class LoginViewModel {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthService.shared.signInWithGoogle(tokens: tokens)
    }
}
