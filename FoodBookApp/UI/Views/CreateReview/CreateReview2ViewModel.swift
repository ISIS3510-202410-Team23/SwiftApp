//
//  CreateReview2ViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import Observation

@Observable
class CreateReview2ViewModel {
    private let reviewRepository: ReviewRepository = ReviewRepositoryImpl.shared
    private let spotRepository: SpotRepository = SpotRepositoryImpl.shared
    var username: String = ""
    
    init() {}
    
    @MainActor
    func addReview(review: Review) async throws -> String {
            do {
                let id = try await reviewRepository.createReview(review: review)
                return id
            } catch {
                throw error
            }
    }
    
    func addReviewToSpot(spotId: String, reviewId: String) async throws {
        do {
            try await spotRepository.updateSpot(docId: spotId, revId: reviewId)
        } catch {
            throw error
        }
    }
    
    func getUsername() async throws {
        do {
            let email = try AuthService.shared.getAuthenticatedUser().email
            if let email = email {
                let usernameComponents = email.split(separator: "@")
                if let username = usernameComponents.first {
                    self.username = String(username)
                } else {
                    throw NSError(domain: "Google", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid email format"])
                }
            } else {
                throw NSError(domain: "Google", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email not found"])
            }
        } catch {
            throw error
        }
    }
    
}
