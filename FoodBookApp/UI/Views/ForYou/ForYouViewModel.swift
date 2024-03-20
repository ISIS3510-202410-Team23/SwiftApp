//
//  ForYouViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 29/02/24.
//

import Observation
import Foundation
import CoreLocation
import FirebaseFirestore

@Observable
class ForYouViewModel {
    var spots: [Spot] = []
    let uid: String = "m.castroi" // FIXME: this should take the UID from user
    private let backendService = BackendService()
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    
    func fetchRecommendedSpots() async throws {
        if let document_ids = try? await backendService.performAPICall(uid: uid){
            spots = try await repository.getSpotsWithIDList(list: document_ids)
        } else {
            print("API call did not work")
        }
    }
    
    private func fetchSpot(id: String) async throws -> Spot {
        return try await repository.getSpotById(docId: id)
    }
    
    private func fetchSpotsWithIDList(li: [String]) async throws -> [Spot] {
        return try await repository.getSpotsWithIDList(list: li)
    }
    
}
