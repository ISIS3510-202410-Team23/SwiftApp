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
    @State private var searchText: String = ""
    @State private var selectedCats: [String] = []
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let customGray2 = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                
                // Header
                ZStack(alignment: .leading) {
                    TextButton(text: "Cancel", txtSize: 20, hPadding: 0) // FIXME: should redirect
                    Text("Review")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 20))
                }.padding()
                
                Separator()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("What did you order?")
                        .font(.system(size: 24))
                        .bold()
                    Text("Select at leat one and up to three categories").foregroundColor(.gray).padding(.top, 5)
                    
                    // Search bar
                    TextField("Search", text: $searchText)
                                        .padding(10)
                                        .background(customGray)
                                        .cornerRadius(8)
                                        .padding(.top, 20)
                    
                }.padding(.horizontal, 20).padding(.top)
                
                // Categories
                ScrollView() {
                    VStack(alignment: .leading, spacing: 0) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading) {
                            ForEach(searchResults, id: \.self) { cat in
                                Button(action: {
                                    if selectedCats.contains(cat) {
                                        selectedCats.removeAll { $0 == cat }
                                    }
                                    else {
                                        if selectedCats.count < 3 {
                                            selectedCats.append(cat)
                                        }
                                    }
                                }, label: {Text(cat)
                                        .font(.system(size: 14))
                                        .bold()
                                        .foregroundColor(selectedCats.contains(cat) ? Color.white : Color.black)
                                        .padding(10)
                                        .background(selectedCats.contains(cat) ? Color.black : customGray)
                                        .cornerRadius(8)})
                            }.padding(.bottom, 5)
                        }.padding(.top, 20)
                    }.padding(.horizontal, 20)

                    Spacer()

                }
                
                Separator()
                
            }.task {
                _ = try? await model.fetchCategories()
            }
        }
        // Next button
        BoldTextButton(text: "Next", txtSize: 24){ print("Next") }.padding() // FIXME: should redirect and verify that at least one has been selected
    }
    
    var searchResults: [String] {
            if searchText.isEmpty {
                return model.categories
            } else {
                return model.categories.filter { cat in
                    cat.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
}

#Preview {
    CreateReview1View()
}
