//
//  ForYouView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI


struct ForYouView: View {
    @State private var model = ForYouViewModel()
    @State private var isFetching = true
    @State private var showNotFoundError = false
    
    var body: some View {
        ScrollView {
            Group {
                if isFetching {
                    ProgressView()
                } else if showNotFoundError {
                    Text("Leave reviews to get personalized recommendations!")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .safeAreaPadding()
                } else {
                    ForEach(model.spots, id: \.self) { spot in
                        NavigationLink(
                            destination: SpotDetailView(spotId: spot.id ?? ""))
                        {
                            SpotCard(
                                id: spot.id ?? "",
                                title: spot.name,
                                minTime: spot.waitTime.min,
                                maxTime: spot.waitTime.max,
                                distance: spot.distance ?? "-",
                                categories: spot.categories,
                                imageLinks: spot.imageLinks ?? [],
                                price: spot.price,
                                spot: spot
                            )
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        .accentColor(.black)
                    }
                }
            }
        }
        .padding(8)
        .task {
            do {
                isFetching = true
                try await model.fetchRecommendedSpots()
                if model.notFoundError {
                    self.showNotFoundError = true
                }
                isFetching = false
            } catch {
            }
        }
    }
}



#Preview {
    ForYouView()
}
