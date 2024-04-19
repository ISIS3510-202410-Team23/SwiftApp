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
    var errorTitle: String = ""
    var errorMsg: String = ""
    
    func signInGoogle() async {
        let helper = SignInGoogleHelper()
        
        do {
            let tokens = try await helper.signIn()
            let authDataResult = try await AuthService.shared.signInWithGoogle(tokens: tokens)
        } catch GIDSignInError.canceled {
            errorTitle = "Canceled Sign-in"
            errorMsg = "You canceled the sign-in flow. If you wish to sign in, press the button again and complete the authentication."
            showAlert = true
        } catch AuthErrorCode.userTokenExpired {
            showAlert = true
            errorTitle = "Expired Token"
            errorMsg = "Your token has expired, please sign out and sign in again/" // TODO: maybe sign them out automatically
        } catch AuthErrorCode.invalidCredential {
            showAlert = true
            errorTitle = "Invalid Crendentials"
            errorMsg = "Your credential is invalid."
        } catch AuthErrorCode.networkError {
            showAlert = true
            errorTitle = "Network Error"
            errorMsg = "A network error occurred while signing you in, please check your connection and try again."
        } catch {
            showAlert = true
            print(error)
            errorTitle = "Something went wrong"
            errorMsg = "An unexpected error has ocurred, please try again."
        }
    }
}
