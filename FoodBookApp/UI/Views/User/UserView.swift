//
//  UserView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/15/24.
//

import SwiftUI
import TipKit

struct UserView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showSignInView: Bool
    @State var notified = NotificationHandler().hasDayPassedSinceLastNotification()
    @State var model = UserViewModel.shared
    
    var user: AuthDataResultModel? {
        do {
            return try AuthService.shared.getAuthenticatedUser()
        } catch {
            return nil
        }
    }
    
    
    @ObservedObject var networkService = NetworkService.shared
    
    
    var body: some View {
        VStack {
            
            HStack {
                if user?.photoUrl != nil {
                    AsyncImage(url: URL(string: user?.photoUrl ?? "")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    .frame(width: 110, height: 110)
                    .cornerRadius(10)
                    
                } else {
                    Image(systemName: "person.crop.rectangle.fill")
                        .font(.largeTitle)
                        .imageScale(.large)
                }
                
                
                VStack {
                    Text(user?.name ?? "")
                        .font(.title2)
                    Text(user?.email ?? "")
                    
                }
                .padding()
            }
            
            
            // TEMPORARY ITEMS
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
                        await model.saveSearchItems()
                        try AuthService.shared.signOut()
                        DBManager().deleteAllImages()
                        DBManager().deleteTables() //TODO: maybe show alert notifying user?
                        NotificationHandler().cancelNotification(identifier: "lastReviewNotification")
                        dismiss()
                    } catch {
                        print("Failed to sign out...")
                        // TODO: show user message
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
}



#Preview {
    UserView(showSignInView: .constant(false))
}
