//
//  UserReviewsViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 13/05/24.
//

import Foundation
import Observation

@Observable
class UserReviewsViewModel {
    
    private let utils = Utils.shared
    var userReviews: [Review] = []
    var username: String = ""
    var user: String?
    
    private let reviewRepository: ReviewRepository = ReviewRepositoryImpl.shared
    
    @MainActor
    func fetchUserReviews() async throws {
        self.userReviews = try await reviewRepository.getUserReviews()
    }
    
    func getUserInfo() async throws {
        self.username = try await utils.getUsername()
        self.user = try await utils.getUser()
    }
}
