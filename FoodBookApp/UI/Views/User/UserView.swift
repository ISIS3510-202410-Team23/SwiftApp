//
//  UserView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/15/24.
//

import SwiftUI
import TipKit
import CachedAsyncImage

struct UserView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showSignInView: Bool
    @State var notified = NotificationHandler().hasDayPassedSinceLastNotification()
    @State var model = UserViewModel.shared
    
    @State private var user: AuthDataResultModel? = nil
    @State private var username: String? = nil
    
    @ObservedObject var networkService = NetworkService.shared
    
    var body: some View {
        NavigationStack {
                    VStack {
                        HStack {
                            if user?.photoUrl != nil {
                                CachedAsyncImage(url: URL(string: user?.photoUrl ?? "")) { img in
                                    img.resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 110, height: 110)
                                .cornerRadius(10)
                                
                                
                                VStack {
                                    Text(user?.name ?? "")
                                        .font(.title2)
                                    Text(user?.email ?? "")
                                    
                                }
                                .padding()
                            }
                        }
                            
                            NavigationLink(destination: UserReviewsView(user: $user, username: .constant(username ?? ""))) {
                                Text("Your reviews")
                            }
                            
                            // MARK: - TEMPORARY ITEMS
                            //            Text(notified ? "Sent" : "Not Sent")
                            //
                            //            Button(action: {
                            //                UserDefaults.standard.removeObject(forKey: "lastNotificationTime")
                            //                notified = NotificationHandler().hasDayPassedSinceLastNotification()
                            //            }, label: {
                            //                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                            //            })
                            //
                            //            // FIXME: Remove, only fro testing Network Service
                            //            if networkService.isOnline {
                            //                Text("Online")
                            //            }
                            //            if networkService.isLowConnection {
                            //                Text("Low Connection")
                            //            }
                            //            if networkService.isUnavailable {
                            //                Text("Unavailble")
                            //            }
                            //
                            //            Button(action: {
                            //                networkService.checkStatus()
                            //            }, label: {
                            //                Text("Status Report")
                            //            })
                            
                            //            Button {
                            //                Tips.showAllTipsForTesting()
                            //            } label: {
                            //                Text("Show tips again")
                            //            }
                            
                            
                            //                 MARK: - Sign out button
                            Button(action: {
                                Task {
                                    do {
                                        print("signing out...")
                                        await model.saveSearchItems()
                                        try AuthService.shared.signOut()
                                        DBManager().deleteAllImages()
                                        DBManager().deleteTables() //TODO: maybe show alert notifying user??
                                        NotificationHandler().cancelNotification(identifier: "lastReviewNotification")
                                        dismiss()
                                    } catch {
                                        print("Failed to sign out...")
                                        // TODO: show user? message
                                    }
                                    model.deleteFileContents()
                                }
                            }, label: {
                                Text("Sign out")
                            })
                            .buttonStyle(.borderedProminent)
                            .padding()
                            
                        }
        }
        .task {
            do {
                user = await model.fetchUser()
                username = try await  Utils.shared.getUsername()
            } catch {
                print("[UserView] Error fetching user? info... \(error)")
            }
        }
    }
}
        



//#Preview {
//    UserView(showSignInView: .constant(false))
//}
