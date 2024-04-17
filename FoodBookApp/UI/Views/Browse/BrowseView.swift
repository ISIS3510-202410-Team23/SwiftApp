//
//  BrowseView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BrowseView: View {
    
    @Binding var searchText: String
    @State private var model = BrowseViewModel()
    @State private var isFetching = false
    @State private var showAlert = false
    @ObservedObject var networkService = NetworkService.shared
    
    var body: some View {
        ScrollView {
            VStack {
                if networkService.isOnline {
                    if !isFetching && searchResults.isEmpty {
                        Text("Hmm, nothing here. Maybe try a different search?")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .safeAreaPadding()
                    } else {
                        ForEach(searchResults, id: \.self) { spot in
                            NavigationLink(destination: SpotDetailView(spotId: spot.id ?? "")){
                                SpotCard(
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
                    
                    if isFetching {
                        ProgressView()
                            .padding()
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
