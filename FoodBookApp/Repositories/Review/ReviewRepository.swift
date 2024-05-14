//
//  ReviewRepository.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import SwiftUI

protocol ReviewRepository {
    static var reviewSA: ReviewSA { get }
    func createReview(review: Review) async throws -> String
    func uploadPhoto(image: UIImage) async throws -> String
    func uploadReviewReport(reviewId: String, reason: String) async throws 
    func getUserReviews() async throws -> [Review]
}
