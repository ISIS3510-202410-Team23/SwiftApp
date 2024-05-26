//
//  UserReviewsView.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 13/05/24.
//

import Foundation
import SwiftUI

struct UserReviewsView: View {
    
    @ObservedObject var networkService = NetworkService.shared
    
    @State private var model = UserReviewsViewModel()
    @State private var isFetching: Bool = true
    
    @Binding var user: AuthDataResultModel?
    @Binding var username: String
    
    var body: some View {
        VStack {
            if isFetching {
                ProgressView()
                    .padding()
            } else {
                if !model.userReviews.isEmpty {
                    VStack {
                        HStack {
                            Text("Latest Reviews")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding([.leading, .top])
                            Spacer()
                            if !networkService.isOnline {
                                HStack {
                                    Image(systemName: "wifi.slash")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                    Text("offline")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                            }
                        }
                        ScrollView(.vertical) {
                            VStack {
                                ForEach(model.userReviews.indices, id: \.self) { index in
                                    let review = model.userReviews[index]
                                    ReviewCard(review: review, userId: username)
                                }
                                .padding(.vertical, 5)
                            }
                            .padding()
                        }
                    }
                } else {
                    Text("Hmm nothing here, make sure you've left reviews or check your internet connection.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
            }
        }
        .task {
            isFetching = true
            _ = try? await model.fetchUserReviews(username: username, userId: user?.uid ?? "", name: user?.name ?? "")
            isFetching = false
        }
        .navigationTitle("My reviews")
    }
}

//#Preview {
//    UserReviewsView(userId: .constant("m.castro.ire"))
//}
