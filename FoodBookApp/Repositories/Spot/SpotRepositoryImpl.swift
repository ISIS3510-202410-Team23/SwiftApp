//
//  SpotRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation

class SpotRepositoryImpl: SpotRepository {
    static var shared: SpotRepository = SpotRepositoryImpl()
    static var spotDao: SpotDAO = SpotDAOFirebase.shared
    
    func getSpotById(docId: String) async throws -> Spot {
        return try await SpotRepositoryImpl.spotDao.getSpotById(documentId: docId)
    }
    
    func getSpots() async throws -> [Spot] {
        return try await SpotRepositoryImpl.spotDao.getSpots()
    }
}
