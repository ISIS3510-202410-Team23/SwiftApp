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
    @State private var showAlert = false
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
        .alert("Please check your internet connection and try again", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
        .onReceive(networkService.$isOnline) { isOnline in
            if !isOnline {
                showAlert = true
            }
        }
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
