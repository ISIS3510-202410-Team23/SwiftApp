//
//  BrowseView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BrowseView: View {
    @Binding var searchText: String
    @Binding var spots: [Spot]
    @Binding var isFetching: Bool
    @Binding var hotCategories: [Category]
    @State private var showHotCategories: Bool = !UserDefaults.standard.bool(forKey: "hideHotCategories")
    
    @ObservedObject var networkService = NetworkService.shared
    
    var body: some View {
        VStack {
            ScrollView {
                if showHotCategories && !hotCategories.isEmpty && searchText.isEmpty {
                    VStack {
                        HStack {
                            Text("\(Image(systemName: "flame")) Popular categories this week")
                                .font(.headline)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showHotCategories = false
                                    UserDefaults.standard.set(true, forKey: "hideHotCategories")
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing)
                        }
                        
                        HCategoryList(categories: hotCategories, color: .gray)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }
                VStack {
                    if searchResults.isEmpty {
                        Text("\(!searchText.isEmpty ? "Hmm, nothing here. Your search for \"\(searchText)\" has no results" : "")")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .safeAreaPadding()
                    } else {
                        ForEach(searchResults, id: \.self) { spot in
                            NavigationLink(destination: SpotDetailView(spotId: spot.id ?? "")){
                                SpotCard(
                                    id: spot.id ?? "",
                                    title: spot.name,
                                    minTime: spot.waitTime.min,
                                    maxTime: spot.waitTime.max,
                                    distance: spot.distance ?? "-",
                                    categories: Array(Utils.shared.highestCategories(spot: spot).prefix(5)),
                                    imageLinks: spot.imageLinks ?? [],
                                    price: spot.price,
                                    spot: spot
                                )
                                .fixedSize(horizontal: false, vertical: true)
                                .accentColor(.black)
                            }
                        }
                    }
                    
                    if isFetching {
                        ProgressView()
                            .padding()
                    }
                    
                }
            }
            .safeAreaPadding()
        }
    }
    
    var searchResults: [Spot] {
        if searchText.isEmpty {
            return self.spots
        } else {
            return self.spots.filter { spot in
                spot.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

//struct BrowseView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrowseView(searchText: .constant(""), spots:[])
//    }
//}
