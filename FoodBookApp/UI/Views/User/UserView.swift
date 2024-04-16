//
//  UserView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/15/24.
//

import SwiftUI

struct UserView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showSignInView: Bool
    @State var isAuthenticated = false
    
    @State var notified = NotificationHandler().hasDayPassedSinceLastNotification()
    
    var user: AuthDataResultModel? {
        do {
            return try AuthService.shared.getAuthenticatedUser()
        } catch {
            return nil
        }
    }
    
    @ObservedObject var networkService = NetworkService.shared
    var body: some View {
        if isAuthenticated {
            VStack {
                
                HStack {
                    if user?.photoUrl != nil {
                        AsyncImage(url: URL(string: user?.photoUrl ?? ""))
                    } else {
                        Image(systemName: "person.crop.rectangle.fill")
                    }
                       
                    
                    VStack {
                        Text(user?.name ?? "")
                            .font(.title2)
                        Text(user?.email ?? "")
                        
                    }
                    .padding()
                }
                

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
                
                // Sign out button
                Button(action: {
                    Task {
                        do {
                            print("signing out...")
                            try AuthService.shared.signOut()
                            DBManager().deleteDraftsTable() //TODO: maybe show alert notifying user?
                            NotificationHandler().cancelNotification(identifier: "lastReviewNotification")
                            dismiss()
//                            showSignInView = true
                        } catch {
                            print("Failed to sign out...")
                            // TODO: show user message
                        }
                    }
                }, label: {
                    Text("Sign out")
                })
                .buttonStyle(.borderedProminent)
                .padding()
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
    UserView(showSignInView: .constant(false))
}
