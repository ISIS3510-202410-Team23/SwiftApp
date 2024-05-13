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
    
    @ObservedObject var networkService = NetworkService.shared
    
    var body: some View {
        VStack {
            if !hotCategories.isEmpty {
                Text("Hot categories this week!") // TODO: Change title
                HCategoryList(categories: hotCategories, color: Color.orange) // Color is temp but maybe we should consider a "special" color so they stand out
            } else {
                
            }
            ScrollView {
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
            .padding(8)
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
