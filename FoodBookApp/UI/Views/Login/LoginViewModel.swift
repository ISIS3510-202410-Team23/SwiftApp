//
//  LoginViewModel.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

@MainActor
@Observable 
final class LoginViewModel {
    
    var showAlert = false
    var errorMsg: String = ""
    
    func signInGoogle() async {
        let helper = SignInGoogleHelper()
        
        do {
            let tokens = try await helper.signIn()
            let authDataResult = try await AuthService.shared.signInWithGoogle(tokens: tokens)
        } catch GIDSignInError.canceled {
            errorMsg = "You canceled the sign-in flow. If you wish to sign in, press the button again and complete the authentication."
            showAlert = true
        } catch AuthErrorCode.userTokenExpired {
            showAlert = true
            errorMsg = "Your token has expired, please sign out and sign in again/" // TODO: maybe sign them out automatically
        } catch AuthErrorCode.invalidCredential {
            showAlert = true
            errorMsg = "Your credential is invalid."
        } catch AuthErrorCode.networkError {
            showAlert = true
            errorMsg = "A network error occurred while signing you in, please check your connection and try again."
        } catch {
            showAlert = true
            print(error)
            errorMsg = "An unexpected error has ocurred, please try again."
        }
    }
}
