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
        } catch SignInError.timeout {
            errorTitle = "No answer recieved"
            errorMsg = "Seems like you took to long to sign-in, check your internet connection and try again."
            showAlert = true
        }
        catch GIDSignInError.canceled {
            errorTitle = "Canceled Sign-in"
            errorMsg = "You canceled the sign-in flow. If you wish to sign in, press the button again and complete the authentication."
            showAlert = true
        } catch AuthErrorCode.userTokenExpired {
            errorTitle = "Expired Token"
            errorMsg = "Your token has expired, please sign out and sign in again/" // TODO: maybe sign them out automatically
            showAlert = true
        } catch AuthErrorCode.invalidCredential {
            errorTitle = "Invalid Crendentials"
            errorMsg = "Your credential is invalid."
            showAlert = true
        } catch AuthErrorCode.networkError {
            errorTitle = "Network Error"
            errorMsg = "A network error occurred while signing you in, please check your connection and try again."
            showAlert = true
        } catch {
            print(error)
            errorTitle = "Something went wrong"
            errorMsg = "An unexpected error has ocurred, please try again."
            showAlert = true
        }
    }
}
