//
//  ReviewDAO.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation

protocol ReviewDAO {
    static var shared: ReviewDAO { get }
    func createReview(review: Review) async throws -> String
}
