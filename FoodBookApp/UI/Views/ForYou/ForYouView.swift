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
    @ObservedObject var networkService = NetworkService.shared
    
    
    var body: some View {
        ScrollView {
            Group {
                if networkService.isOnline {
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
                } else {
                    Text("Nothing here... yet!")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .safeAreaPadding()
                }
            }
        }
        .padding(8)
        .task {
            if networkService.isOnline { // IMPORTANT, REMOVING THIS WILL MAKE THE APP CRASH WITHOUT INTERNET
                isFetching = true
                let _ = try? await model.fetchRecommendedSpots()
//                if model.spots == [] {
//                    showNotFoundError = true
//                } else {
//                    showNotFoundError = false
//                }
                isFetching = false
            }
        }
        
    }
}



#Preview {
    ForYouView()
}
