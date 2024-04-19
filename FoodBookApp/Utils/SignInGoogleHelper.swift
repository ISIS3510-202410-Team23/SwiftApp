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

final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utils.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        do {
            let gidSignInResult = try await self.signInWithTimeout(withPresenting: topVC)
            print("result \(gidSignInResult)")
            guard let idToken = gidSignInResult.user.idToken?.tokenString else {
                throw URLError(.badServerResponse)
            }
            
            let accessToken = gidSignInResult.user.accessToken.tokenString
            let name = gidSignInResult.user.profile?.name
            let email = gidSignInResult.user.profile?.email
            
            let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
            return tokens
        } catch {
            print("err: ", error)
            throw error
        }
        
    }
    
    func signInWithTimeout(withPresenting topVC: UIViewController) async throws -> GIDSignInResult {
        
        let signInTask = Task { @MainActor  in
            try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        }
        
        let timeoutTask = Task (priority: .background) {
//            print("start timeout")
            try await Task.sleep(for: .seconds(10)) // User has 30 seconds to complete login process
//            print("end timeout")
            await topVC.dismiss(animated: true)
            try Task.checkCancellation()
            print(signInTask.isCancelled)
            signInTask.cancel()
            print(signInTask.isCancelled)
            signInTask.cancel()
            //
            throw CancellationError()
        }
        
        return try await withTaskCancellationHandler {
            print("operation start")
            let result = try await signInTask.value
            //            timeoutTask.cancel()
            return result
            
        } onCancel: {
            print("oncancele")
        }
    }
}
