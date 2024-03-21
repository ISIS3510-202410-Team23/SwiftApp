//
//  BrowseView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BrowseView: View {    
    @State private var model = BrowseViewModel()
    @Binding var searchText: String
    
    var body: some View {
        ScrollView {
            Group {
                ForEach(searchResults, id: \.self) { spot in
                    NavigationLink(destination: SpotDetailView(spotId: spot.id ?? "")){ 
                        SpotCard(
                            title: spot.name,
                            minTime: spot.waitTime.min,
                            maxTime: spot.waitTime.max,
                            distance: spot.distance ?? "-",
                            categories: spot.categories,
                            imageLinks: spot.imageLinks ?? [],
                            price: spot.price
                        )
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .accentColor(.black)
                }
            }
            .searchable(text: $searchText)
        }
        .padding(8)
        .task {
            _ = try? await model.fetchSpotsAndCalculateDistance()
        }
    }
    
    var searchResults: [Spot] {
        if searchText.isEmpty {
            return model.spots
        } else {
            return model.spots.filter { spot in
                spot.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView(searchText: .constant(""))
    }
}
