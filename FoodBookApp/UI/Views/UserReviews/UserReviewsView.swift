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
    
    var body: some View {
        VStack {
            if !model.userReviews.isEmpty {
                ScrollView(.vertical) {
                    VStack {
                        ForEach(model.userReviews.reversed(), id: \.self) { review in
                            ReviewCard(review: review, userId: model.username)
                        }.padding(.vertical, 5)
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text("You haven't left any reviews yet…")
                Spacer()
            }
        }.task {
            _ = try? await model.fetchUserReviews()
            _ = try? await model.getUserInfo()
        }.navigationTitle("Your reviews")
    }
}

#Preview {
    UserReviewsView()
}
