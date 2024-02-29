//
//  BrowseView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BrowseView: View {
    @State private var model = BrowseViewModel()
    
    var body: some View {
        // TODO: Missing searchbar for spots
        // TODO: Missing filter for categories
        ScrollView(content: {
            ForEach(model.spots, id: \.self) { spot in
                SpotCard(
                    title: spot.name,
                    minTime: spot.minTime,
                    maxTime: spot.maxTime,
                    distance: Float(spot.distance),
                    categories: spot.categories
                )
                .fixedSize(horizontal: false, vertical: true)
            }
        })
        .padding(8)
        .task {
            _ = try? await model.fetchSpots()
        }

    }
}


#Preview {
    BrowseView()
}
