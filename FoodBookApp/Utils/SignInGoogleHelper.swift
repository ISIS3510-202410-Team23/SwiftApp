//
//  SignInGoogleHelper.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation
import GoogleSignIn

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

@Observable
final class SignInGoogleHelper {
    
    static let shared = SignInGoogleHelper()
    
    var timeoutComplete = false
    var flowComplete = false
    
    func signIn() async throws -> GoogleSignInResultModel {
        
        guard let topVC = await Utils.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        do {
            let gidSignInResult = try await self.signInWithTimeout(withPresenting: topVC)
            flowComplete = true
            guard let idToken = gidSignInResult?.user.idToken?.tokenString else {
                throw URLError(.badServerResponse)
            }
            
            let accessToken = gidSignInResult?.user.accessToken.tokenString
            let name = gidSignInResult?.user.profile?.name
            let email = gidSignInResult?.user.profile?.email
            
            let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken ?? "", name: name, email: email)
            return tokens
        } catch {
            flowComplete = true
            print("err: ", error)
            throw error
        }
        
    }
    
    func signInWithTimeout(withPresenting topVC: UIViewController) async throws -> GIDSignInResult? {
        
        flowComplete = false
        timeoutComplete = false
        
        let signInTask = Task { @MainActor  in
            return try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        }
        
        let timeoutTask = Task (priority: .userInitiated) {
            try await Task.sleep(for: .seconds(45)) // User has 45 seconds to complete login process
            print("tC", timeoutComplete)
            print("sC", flowComplete)
            if !flowComplete {
                await topVC.dismiss(animated: true)
                DispatchQueue.main.async {
                    self.timeoutComplete = true
                }
            }

            return
        }
        
        return try await withTaskCancellationHandler {
            print("operation start")
            let result = try await signInTask.value
            timeoutTask.cancel()
            return result
            
        } onCancel: {
            print("onCancel")
        }
    }
}
