//
//  LoginView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/24/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
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
            Button(action: {
                    print("Login in...") // FIXME: Should connect to microsoft API
                }, label: {
                    Image("uniandes-logo")
                        .resizable()
                       .frame(width: 25, height: 25)
                    Text("Continue with Uniandes")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                })
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
