//
//  BookmarksView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BookmarksView: View {
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        
        VStack {
            // FIXME: the following content is temporary
            Image(systemName: "book")
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .font(.system(size: 100))
            
            // FIXME: sign out button for testing only
            Button(action: {
                Task {
                    do {
                        print("signing out...")
                        try AuthService.shared.signOut()
                        showSignInView = true
                        
                    } catch {
                        print("Failed to sign out...")
                    }
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
    BookmarksView(showSignInView: .constant(false))
}
