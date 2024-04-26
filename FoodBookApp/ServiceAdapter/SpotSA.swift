//
//  SpotsSA.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation


protocol SpotSA {
    static var shared: SpotSA { get }
    func getSpotById(documentId: String) async throws -> Spot
    func getSpots() async throws -> [Spot]
    func getSpotsWithIDList(docIDs: [String]) async throws -> [Spot]
    func updateSpot(documentId: String, reviewId: String) async throws
}
