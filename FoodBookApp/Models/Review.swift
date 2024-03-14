//
//  Review.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import FirebaseFirestore

struct ReviewStats: Codable, Equatable, Hashable {
    let cleanliness: Int
    let foodQuality: Int
    let service: Int
    let waitTime: Int
}

struct Review: Codable, Equatable, Hashable, Identifiable {
    @DocumentID var id: String?
    let content: String!
    let date: Date
    let imageUrl: String!
    let ratings: ReviewStats
    let selectedCategories: [String]
    let title: String!
    let user: String // AuthoUserModel.uid from Authentication (getAuthenticatedUser)
}
