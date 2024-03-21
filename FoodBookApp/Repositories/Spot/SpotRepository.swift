//
//  SpotRepository.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation

protocol SpotRepository {
    static var spotDao: SpotDAO { get }

    func getSpotById(docId: String) async throws -> Spot
    func getSpots() async throws -> [Spot]
    func getSpotsWithIDList(list: [String]) async throws -> [Spot]
    func updateSpot(docId: String, revId: String) async throws
}
