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
    @State var isAuthenticated = false
    @ObservedObject var networkService = NetworkService.shared
    
    //TODO: move this to sign out view if created
    let notify = NotificationHandler()
    
    @State var notified = NotificationHandler().hasDayPassedSinceLastNotification()
    
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
                
                Text(notified ? "Sent" : "Not Sent")
                
                Button(action: {
                    UserDefaults.standard.removeObject(forKey: "lastNotificationTime")
                    notified = NotificationHandler().hasDayPassedSinceLastNotification()
                }, label: {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                })
                
                // FIXME: Remove, only fro testing Network Service
                if networkService.isOnline {
                    Text("Online")
                }
                if networkService.isLowConnection {
                    Text("Low Connection")
                }
                if networkService.isUnavailable {
                    Text("Unavailble")
                }
                
                Button(action: {
                    networkService.checkStatus()
                }, label: {
                    Text("Status Report")
                })
            }
            
        } else {
            VStack {
                Text("Please confirm it's you to proceed")
                    .font(.title)
                    .padding()
                Button("Authenticate") {
                    AuthService.shared.authenticateUser { success in
                        if success {
                            isAuthenticated = true
                            print("Authentication successful")
                        } else {
                            print("Authentication failed")
                        }
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    BookmarksView(showSignInView: .constant(false))
}
