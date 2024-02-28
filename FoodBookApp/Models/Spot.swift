//
//  Spot.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 26/02/24.
//

import Foundation

struct Spot: Codable, Equatable, Hashable {
    let id: String
    let name: String
    let minTime: Int
    let maxTime: Int
    let distance: Double
    let latitude: String
    let longitude: String
    let categories: [String]
}
