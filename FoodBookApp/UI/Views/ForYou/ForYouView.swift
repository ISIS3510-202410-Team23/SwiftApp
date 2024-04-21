//
//  ForYouView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI


struct ForYouView: View {
    
    @Binding var spots: [Spot]
    @Binding var isFetching: Bool
    @Binding var noReviewsFlag: Bool
    
    
    @ObservedObject var networkService = NetworkService.shared
    
    
    var body: some View {
        ScrollView {
            Group {
                if noReviewsFlag {
                    Text("Leave reviews to get personalized recommendations!")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .safeAreaPadding()
                } else if spots.isEmpty {
                    Text("Crunching up the latest spots for you")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .safeAreaPadding()
                } else {
                    ForEach(self.spots, id: \.self) { spot in
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
                if isFetching {
                    ProgressView()
                }
            }
        }
        .padding(8)
        
    }
}



//#Preview {
//    ForYouView(spots: [])
//}
