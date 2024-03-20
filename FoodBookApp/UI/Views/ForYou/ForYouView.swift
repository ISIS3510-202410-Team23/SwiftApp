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
        ScrollView {
            Group {
                ForEach(model.spots, id: \.self) { spot in
                    NavigationLink(
                        destination: SpotDetailView(spotId: spot.id ?? ""))
                    {
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
        }
        .padding(8)
        .task {
            _ = try? await model.fetchRecommendedSpots()
        }
    }
}

#Preview {
    ForYouView()
}
