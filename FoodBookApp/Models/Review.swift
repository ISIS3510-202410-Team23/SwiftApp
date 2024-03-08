//
//  Review.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation

struct Review: Hashable {
    let cleanliness: Int
    let waitingTime: Int
    let service: Int
    let foodQuality: Int
    let tags: [String]
    let description: String
    let title: String
    let photo: String
    let user: String
    let date: Date
}
