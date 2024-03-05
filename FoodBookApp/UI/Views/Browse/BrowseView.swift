//
//  BrowseView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI



struct BrowseView: View {
    @State private var model = BrowseViewModel()
    let locationService = LocationService.shared
    @Binding var searchText: String
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(searchResults, id: \.self) { spot in
                    SpotCard(
                        title: spot.name,
                        minTime: spot.minTime,
                        maxTime: spot.maxTime,
                        distance: Float(spot.distance),
                        categories: spot.categories,
                        colors: [.cyan, .indigo, .teal, .pink, .mint, .purple]
                    )
                    .fixedSize(horizontal: false, vertical: true)
                }
            }.searchable(text: $searchText)
        }
        .padding(8)
        .task {
            _ = try? await model.fetchSpots()
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
