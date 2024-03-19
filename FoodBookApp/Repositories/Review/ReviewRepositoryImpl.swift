//
//  ReviewRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation

class ReviewRepositoryImpl: ReviewRepository {
    static var shared: ReviewRepository = ReviewRepositoryImpl()
    static var reviewDao: ReviewDAO = ReviewDAOFirebase.shared
    
    func createReview(review: Review) async throws -> String {
        return try await ReviewRepositoryImpl.reviewDao.createReview(review: review)
    }
}
