//
//  RootView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/27/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
        
        var body: some View {
            ZStack {
                if !showSignInView {
                    ContentView(showSignInView: $showSignInView)
                }
            }
            .onAppear {
                let authUser = try? AuthService.shared.getAuthenticatedUser()
                self.showSignInView = authUser == nil
            }
            .fullScreenCover(isPresented: $showSignInView) {
                NavigationStack {
                    LoginView(showSignInView: $showSignInView)
                }
            }
        }
}

#Preview {
    RootView()
}
