//
//  BrowseViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 26/02/24.
//
import Observation
import Foundation
import CoreLocation
import FirebaseFirestore //FIXME: delete later

@Observable
class BrowseViewModel {
    var spots: [Spot] = []
    let locationService = LocationService.shared
    let locationUtils = LocationUtils()
    
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    
    func fetchSpotsAndCalculateDistance() async throws {
        spots = try await fetchSpots()
        calculateDistance()
    }
    
    private func fetchSpots() async throws -> [Spot] {
        return try await repository.getSpots()
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

