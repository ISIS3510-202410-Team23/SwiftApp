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
    var uid: String = ""
    var documentIds: [String] = []
    
    private let backendService = BackendService()
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    private let locationService = LocationService.shared
    private let locationUtils = LocationUtils()
    private let utils = Utils.shared
    
    func fetchRecommendedSpots() async throws {
        try await getUsername()
        while true {
            do {
                let dids = try await backendService.performAPICall(uid: uid)
                if !dids.isEmpty {
                    self.documentIds = dids
                    break
                }
                if dids.isEmpty {
                    self.uid = "AAAAAAA"
                }
            } catch {
                print("Error fetching recommended spots: \(error)")
                throw error
            }
        }
        
        spots = try await repository.getSpotsWithIDList(list: documentIds)
        calculateDistance()
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
    
    func getUsername() async throws {
        do {
            self.uid = try await utils.getUsername()
        } catch {
            self.uid = "userID"
        }
    }

}
