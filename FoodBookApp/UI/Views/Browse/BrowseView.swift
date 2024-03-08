//
//  BrowseView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI



struct BrowseView: View {
    let locationService = LocationService.shared
    
    @State private var model = BrowseViewModel()
    
    @Binding var searchText: String
    
    var body: some View {
        ScrollView {
            Group {
                ForEach(searchResults, id: \.self) { spot in
                    NavigationLink(destination: SpotDetailView()){ // TODO: In the future this should have the SpotId as param
                        SpotCard(
                            title: spot.name,
                            minTime: spot.minTime,
                            maxTime: spot.maxTime,
                            distance: Float(spot.distance),
                            categories: spot.categories,
                            imageLinks: spot.imageLinks
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
