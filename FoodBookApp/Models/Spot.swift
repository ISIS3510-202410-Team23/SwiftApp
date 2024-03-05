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
    let latitude: Double
    let longitude: Double
    let categories: [String]
}
