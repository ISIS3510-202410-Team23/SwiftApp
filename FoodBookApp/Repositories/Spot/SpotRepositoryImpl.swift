//
//  SpotRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation

class SpotRepositoryImpl: SpotRepository {
    static var shared: SpotRepository = SpotRepositoryImpl()
    static var spotSA: SpotSA = SpotSAFirebase.shared
    
    func getSpotById(docId: String) async throws -> Spot {
        return try await SpotRepositoryImpl.spotSA.getSpotById(documentId: docId)
    }
    
    func getSpots() async throws -> [Spot] {
        return try await SpotRepositoryImpl.spotSA.getSpots()
    }
    
    func getSpotsWithIDList(list: [String]) async throws -> [Spot] {
        return try await SpotRepositoryImpl.spotSA.getSpotsWithIDList(docIDs: list)
    }   
    
    func updateSpot(docId: String, revId: String) async throws {
        return try await SpotRepositoryImpl.spotSA.updateSpot(documentId: docId, reviewId: revId)
    }
}
