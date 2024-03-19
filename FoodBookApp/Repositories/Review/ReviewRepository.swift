//
//  ReviewRepository.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation

protocol ReviewRepository {
    static var reviewDao: ReviewDAO { get }
    func createReview(review: Review) async throws -> String
}
