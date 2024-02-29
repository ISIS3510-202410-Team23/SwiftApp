//
//  CreateReviewView.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import SwiftUI

struct CreateReview1View: View {
    @State private var model = CreateReview1ViewModel()
    @State private var searchTerm = ""
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                
                // Header
                ZStack(alignment: .leading) {
                    cancelButton
                    Text("Review")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 20))
                }.padding()
                
                // Separator
                Rectangle()
                    .fill(.gray).frame(height: 0.5)
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("What did you order?")
                            .font(.system(size: 24))
                            .bold()
                        Text("Select up to three categories").foregroundColor(.gray)
                    }.padding(.horizontal, 20).padding(.vertical)
                    
                    // TODO: search bar
                    
                    // TODO: categories
                    
                    Spacer()

                }
                
                // Separator
                Rectangle()
                    .fill(.gray).frame(height: 0.5)
                
            }.task {
                _ = try? await model.fetchCategories()
            }
        }
        // Next button
        nextButton.padding()
    }
    
    var cancelButton: some View {
            Button(action: {
                print("Redirecting to spot's detail...") // FIXME: Should actually redirect
            }) {
                Text("Cancel")
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
            }
    }
    
    var nextButton: some View {
        Button(action: {
            print("Redirecting to review pt. 2...") // FIXME: Should actually redirect
        }) {
            Text("Next")
                .foregroundColor(.blue)
                .font(.system(size: 24))
                .bold()
        }
    }
}

#Preview {
    CreateReview1View()
}
