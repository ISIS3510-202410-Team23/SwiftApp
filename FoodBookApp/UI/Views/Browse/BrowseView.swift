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
    @State private var isFetching = false // Track fetching status
    
    var body: some View {
        ScrollView {
            VStack {
                if !isFetching && searchResults.isEmpty {
                    Text("Hmm, nothing here. Maybe try a different search?")
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
                                price: spot.price
                            )
                            .fixedSize(horizontal: false, vertical: true)
                            .accentColor(.black)
                        }
                    }
                }
                
                // Progress View
                if isFetching {
                    ProgressView()
                        .padding()
                }
            }
        }
        .padding(8)
        .task {
            isFetching = true
            _ = try? await model.fetchSpotsAndCalculateDistance()
            isFetching = false
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
