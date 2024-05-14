//
//  BookmarksView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BookmarksView: View {
    

    @Environment(BookmarksService.self) private var bookmarksManager
    @State private var model = BookmarksViewModel()

    @State private var isFetching = false // Track fetching status
    
    @ObservedObject var networkService = NetworkService.shared

    
    var body: some View {
        
        if bookmarksManager.noBookmarks() {
            VStack {
                Text("You have no saved bookmarks.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .safeAreaPadding()
            }
        }
        else {
            ScrollView {
                if isFetching {
                    ProgressView()
                } else if model.spots.isEmpty {
                    Text("Hmm, you've saved bookmarks but there's nothing here. Please verify you are connected to the internet.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .safeAreaPadding()
                } else {
                    ForEach(model.spots, id: \.self) {spot in
                        NavigationLink(destination: SpotDetailView(spotId: spot.id ?? "")){
                            SpotCard(
                                id: spot.id ?? "",
                                title: spot.name,
                                minTime: spot.waitTime.min,
                                maxTime: spot.waitTime.max,
                                distance: spot.distance ?? "-",
                                categories: Array(Utils.shared.highestCategories(spot: spot).prefix(5)),
                                imageLinks: spot.imageLinks ?? [],
                                price: spot.price,
                                spot: spot
                            )
                            .fixedSize(horizontal: false, vertical: true)
                            .accentColor(.black)
                        }
                    }
                }
            }
            .padding(8)
            .task {
                isFetching = true
                await model.fetchSpots(bookmarksManager.getBookmarks())
                isFetching = false
            }
            .onReceive(NetworkService.shared.$isOnline) { isOnline in
                print("Spots is empty but online, retrying...")
                Task {
                    await model.fetchSpots(bookmarksManager.getBookmarks())
                }

            }
        }
    }
}

#Preview {
    BookmarksView()
}
