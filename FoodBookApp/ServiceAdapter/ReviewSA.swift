//
//  ReviewSA.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import SwiftUI

protocol ReviewSA {
    static var shared: ReviewSA { get }
    func createReview(review: Review) async throws -> String
    func uploadPhoto(image: UIImage) async throws -> String
    func uploadReviewReport(reviewId: String, reason: String) async throws
    func getUserReviews(name: String, username: String) async throws -> [Review]
}
