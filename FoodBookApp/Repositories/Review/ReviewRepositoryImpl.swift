//
//  ReviewRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import SwiftUI

class ReviewRepositoryImpl: ReviewRepository {
    static var shared: ReviewRepository = ReviewRepositoryImpl()
    static var reviewSA: ReviewSA = ReviewSAFirebase.shared
    
    func createReview(review: Review) async throws -> String {
        return try await ReviewRepositoryImpl.reviewSA.createReview(review: review)
    }
    
    func uploadPhoto(image: UIImage) async throws -> String {
        return try await ReviewRepositoryImpl.reviewSA.uploadPhoto(image: image)
    }
    
    func uploadReviewReport(reviewId: String, reason: String) async throws {
        return try await ReviewRepositoryImpl.reviewSA.uploadReviewReport(reviewId: reviewId, reason: reason)
    }
    
    func getUserReviews() async throws -> [Review] {
        return try await ReviewRepositoryImpl.reviewSA.getUserReviews()
    }
}
