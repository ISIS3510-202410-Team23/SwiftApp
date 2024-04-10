//
//  BookmarksView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI
import LocalAuthentication

struct BookmarksView: View {
    @Binding var showSignInView: Bool
    @State private var isAuthenticated = false
    
    //TODO: move this to sign out view if created
    let notify = NotificationHandler()
    
    var user: AuthDataResultModel? {
        do {
            return try AuthService.shared.getAuthenticatedUser()
        } catch {
            return nil
        }
    }
    
    var body: some View {
        if isAuthenticated {
            VStack {
                // FIXME: the following content is temporary
                Image(systemName: "book")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 100))
                
                Button(action: {
                    Task {
                        do {
                            print("signing out...")
                            try AuthService.shared.signOut()
                            showSignInView = true
                            
                            //TODO: move this to sign out view if created
                            notify.cancelNotification(identifier: "lastReviewNotification")
                            
                        } catch {
                            print("Failed to sign out...")
                        }
                    }
                }, label: {
                    Text("Sign out")
                })
                .buttonStyle(.borderedProminent)
                .padding()
                Text(user?.name ?? "")
                Text(user?.email ?? "")
            }
        } else {
            VStack {
                Text("Please confirm it's you to proceed")
                    .font(.title)
                    .padding()
                Button("Authenticate") {
                    authenticateUser()
                }
                .padding()
            }
        }
    }
    
    private func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock to access content") { success, authenticationError in
                if success {
                    isAuthenticated = true
                } else {
                    print("Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                }
            }
        } else {
            print("Biometric authentication unavailable: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}

#Preview {
    BookmarksView(showSignInView: .constant(false))
}
