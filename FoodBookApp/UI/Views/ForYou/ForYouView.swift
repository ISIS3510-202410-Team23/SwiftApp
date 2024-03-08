//
//  ForYouView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct ForYouView: View {
    @State private var model = ForYouViewModel()
    var body: some View {
        ScrollView(content: {
            ForEach(model.spots, id: \.self) { spot in
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
        })
        .padding(8)
        .task {
            _ = try? await model.fetchRecommendedSpots(uid: "TODO: This is a user id")
        }
    }
}

#Preview {
    ForYouView()
}
