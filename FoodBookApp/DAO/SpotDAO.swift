//
//  SpotsDAO.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation

// Protocols are sort of like Java Interfaces. Here is the documentation https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/
protocol SpotDAO {
    static var shared: SpotDAO { get }
    func getSpotById(documentId: String) async throws -> Spot
    func getSpots() async throws -> [Spot]
}
