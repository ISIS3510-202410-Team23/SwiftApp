//
//  LoginView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/24/24.
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
struct LoginView: View {
    
    @State private var viewModel = LoginViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            
            // Application Name
            HStack {
                Text("foodbook")
                    .font(.custom("ArchivoBlack-Regular", size: 48))
                    .frame(alignment: .leading) // Aligns the text to the leading edge (left side)
                    .padding(.leading) // Adds padding to the leading edge (left side)
                Spacer()
            }
            
            // Welcome page logo
            Image("toasty")
                .resizable()
                .scaledToFit()
                .padding()
            
            // Application Tagline
            HStack{
                Text("Where good people find good food.") // TODO: i18n string
                    .font(.system(size: 30, weight: .regular, design: .default))
                    .frame(alignment: .leading) // Aligns the text to the leading edge (left side)
                    .padding(.leading) // Adds padding to the leading edge (left side)
                Spacer()
            }
            .padding(.bottom, 30)
            
            // Button to log in
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        print("Successfully signed in.") 
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
                
            }
            .padding()
            
            
            // Keeping old Button code for reference
            
            //            Button(action: {
            //                    print("Login in...")
            //                }, label: {
            //                    Image("uniandes-logo")
            //                        .resizable()
            //                       .frame(width: 25, height: 25)
            //                    Text("Continue with Uniandes")
            //                        .frame(maxWidth: .infinity)
            //                        .padding(.vertical, 5)
            //                })
            //            .buttonStyle(.borderedProminent)
            //            .padding()
        }
        .padding()
    }
}

#Preview {
    LoginView(showSignInView: .constant(true))
}
