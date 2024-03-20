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
    let locationService = LocationService.shared
    let locationUtils = LocationUtils()
    
    func fetchRecommendedSpots() async throws {
        if let document_ids = try? await backendService.performAPICall(uid: uid){
            spots = try await repository.getSpotsWithIDList(list: document_ids)
            calculateDistance()
        } else {
            print("API call did not work")
        }
    }
    
    private func fetchSpotsWithIDList(li: [String]) async throws -> [Spot] {
        return try await repository.getSpotsWithIDList(list: li)
    }
    
    private func calculateDistance() {
        Task {
            for index in spots.indices {
                spots[index].distance = locationUtils.calculateDistance(
                    fromLatitude: spots[index].location.latitude,
                    fromLongitude: spots[index].location.longitude,
                    toLatitude: locationService.userLocation?.coordinate.latitude ?? 0,
                    toLongitude: locationService.userLocation?.coordinate.longitude ?? 0)
            }
        }
    }
}
