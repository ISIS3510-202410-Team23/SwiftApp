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
    private let reviewRepository: ReviewRepository = ReviewRepositoryImpl.shared
    private let spotRepository: SpotRepository = SpotRepositoryImpl.shared
    private let utils = Utils.shared
    var username: String = ""
    var user: String?
    
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
    
    func uploadPhoto(image: UIImage?) async throws -> String? {
        guard let image = image else {
                return nil
            }
        do {
            let url = try await reviewRepository.uploadPhoto(image: image)
            return url
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
    
    func getUserInfo() async throws {
        self.username = try await utils.getUsername()
        self.user = try await utils.getUser()
    }
    
}
