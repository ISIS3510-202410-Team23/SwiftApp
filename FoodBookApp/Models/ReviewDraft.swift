//
//  ReviewDraft.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 14/04/24.
//

import Foundation

struct ReviewDraftStats: Codable, Equatable, Hashable {
    let cleanliness: Int
    let foodQuality: Int
    let service: Int
    let waitTime: Int
}

struct ReviewDraft: Codable, Equatable, Hashable {
    let content: String!
    //let imagePath: String!
    let ratings: ReviewDraftStats
    let selectedCategories: [String]
    let title: String!
}
