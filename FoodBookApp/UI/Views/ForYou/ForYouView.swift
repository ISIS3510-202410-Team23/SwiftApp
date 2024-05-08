//
//  ForYouView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI
import TipKit


struct ForYouView: View {
    
    @Binding var spots: [Spot]
    @Binding var isFetching: Bool
    @Binding var noReviewsFlag: Bool
    
    
    @ObservedObject var networkService = NetworkService.shared
    
    struct ForYouExplanationTip: Tip {
        var title: Text {
            Text("Find more places with for you")
        }


        var message: Text? {
            Text("Explore tailored suggestions based on your recent reviews. Haven't left any reviews yet? Don't worry, we'll need a few to get started!")
        }


        var image: Image? {
            Image(systemName: "star")
        }
    }
    
    var forYouExplanationTip = ForYouExplanationTip()
    
    var body: some View {
        ScrollView {
            TipView(forYouExplanationTip, arrowEdge: .top)
            Group {
                if noReviewsFlag {
                    Text("Leave reviews to get personalized recommendations!")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .safeAreaPadding()
                } else if spots.isEmpty {
                    Text("\(!networkService.isOnline ? "Hmm something went wrong. Please verify you are connected to the internet":"Crunching up the latest spots for you")")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .safeAreaPadding()
                } else {
                    ForEach(self.spots, id: \.self) { spot in
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
                if isFetching {
                    ProgressView()
                }
            }
        }.onAppear { // TODO: add this to other view maybe?
            Task {
                do {
                    if networkService.isOnline {
                        try await DBManager().uploadReviews()
                    }
                } catch {
                    print("Error uploading reviews: ", error.localizedDescription)
                }
            }
        }
        .padding(8)
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate)
            ])
        }
        
    }
}



//#Preview {
//    ForYouView(spots: [])
//}
