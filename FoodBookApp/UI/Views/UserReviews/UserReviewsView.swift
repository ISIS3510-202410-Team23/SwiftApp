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
                    ScrollView(.vertical) {
                        VStack {
                            ForEach(model.userReviews.reversed(), id: \.self) { review in
                                ReviewCard(review: review, userId: username)
                            }.padding(.vertical, 5)
                        }
                        .padding()
                    }
                } else {
                    // TODO: Style this like others...
                    Text("Hmm nothing here, make sure you've left reviews or check your internet connection. ")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .safeAreaPadding()
                    Spacer()
                }
            }
        }.task {
            isFetching = true
            _ = try? await model.fetchUserReviews(username: username, userId: user?.uid ?? "", name: user?.name ?? "")
            isFetching = false
        }.navigationTitle("Your reviews")
    }
}

//#Preview {
//    UserReviewsView(userId: .constant("m.castro.ire"))
//}
