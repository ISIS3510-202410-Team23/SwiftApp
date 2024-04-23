//
//  CreateReview2ViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
class CreateReview2ViewModel {
    private let utils = Utils.shared
    var username: String = ""
    var user: String?
    
    init() {}
    
    @MainActor
    func addReview(review: Review) async throws -> String {
        let reviewId = try await utils.addReview(review: review)
        return reviewId
    }
    
    func uploadPhoto(image: UIImage?) async throws -> String? {
        let reviewImage = try await utils.uploadPhoto(image: image)
        return reviewImage
    }
    
    func addReviewToSpot(spotId: String, reviewId: String) async throws {
        try await utils.addReviewToSpot(spotId: spotId, reviewId: reviewId)
    }
    
    func getUserInfo() async throws {
        self.username = try await utils.getUsername()
        self.user = try await utils.getUser()
    }
    
}
