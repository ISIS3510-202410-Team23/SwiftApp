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
    @FocusState private var searchTextIsFocused: Bool
    @State private var selectedCats: [String] = []
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let customGray2 = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                
                // Header
                HStack{
                    TextButton(text: "Cancel", txtSize: 20, hPadding: 0) // FIXME: should redirect
                    Spacer()
                    Text("Review")
                        .bold()
                        .font(.system(size: 20))
                    Spacer()
                    BoldTextButton(text: "Next", txtSize: 20) { print("Next") } // FIXME: should verify inputs and send them to DB
                    
                }.padding(.horizontal).padding(.top)
                
                Separator()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("What did you order?")
                        .font(.system(size: 24))
                        .bold()
                    Text("Select at least one and up to three categories").foregroundColor(.gray).padding(.top, 5)
                    
                    // Search bar
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(customGray)
                            .frame(height: 40)
                            .padding(.top, 20)
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                                .padding(.leading, 10)
                            TextField("Search", text: $searchText)
                                .padding(.vertical, 10)
                                .cornerRadius(8)
                                .focused($searchTextIsFocused)
                                .padding(.top, 20)
                            if searchTextIsFocused {
                                ClearButton(){
                                    searchText = ""
                                    searchTextIsFocused = false
                                }.padding(.top, 20).padding(.trailing, 10)
                            }
                        }
                    }
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
                
            }.task {
                _ = try? await model.fetchCategories()
            }
        }
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
