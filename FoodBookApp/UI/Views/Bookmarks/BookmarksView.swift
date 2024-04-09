//
//  BookmarksView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BookmarksView: View {
    @Binding var showSignInView: Bool
    
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

    }
}

#Preview {
    BookmarksView(showSignInView: .constant(false))
}
