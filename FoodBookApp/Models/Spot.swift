//
//  Spot.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 26/02/24.
//

import Foundation
import FirebaseFirestore

struct WaitTime: Codable, Equatable, Hashable {
    let min: Int
    let max: Int
}

struct SpotStats: Codable, Equatable, Hashable {
    let cleanliness: Double
    let foodQuality: Double
    let service: Double
    let waitTime: Double
}

struct ReviewData: Codable, Equatable, Hashable {
    let stats: SpotStats
    let userReviews: [Review]
}

struct ReviewDataDTO: Codable, Equatable, Hashable {
    let stats: SpotStats
    let userReviews: [DocumentReference]
}

struct SpotDTO: Codable, Equatable, Hashable {
    @DocumentID var id: String?
    let categories: [String]
    let location: GeoPoint
    let name: String
    let price: String
    let waitTime: WaitTime
    let reviewData: ReviewDataDTO
    let imageLinks: [String]?
}

struct Spot: Codable, Equatable, Hashable {
    @DocumentID var id: String?
    let categories: [String]
    let location: GeoPoint
    let name: String
    let price: String
    let waitTime: WaitTime
    let reviewData: ReviewData
    let imageLinks: [String]?

}
