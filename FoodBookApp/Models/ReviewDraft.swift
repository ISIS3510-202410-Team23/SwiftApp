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
    let selectedCategories: [String]
    let ratings: ReviewDraftStats
    let image: String //this is a path
    let title: String
    let content: String
}
