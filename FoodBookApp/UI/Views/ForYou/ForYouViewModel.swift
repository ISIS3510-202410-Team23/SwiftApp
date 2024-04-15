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
    var notFoundError = false
    
    private let backendService = BackendService()
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    private let locationService = LocationService.shared
    private let locationUtils = LocationUtils()
    private let utils = Utils.shared
    
    func fetchRecommendedSpots() async throws {
        try await getUsername()

        do {
            let spots = try await performAPICall(uid: self.uid)

            if !spots.isEmpty {
                self.documentIds = spots
            } else {
                print("Error: Spots is an empty list")
            }
        } catch {
            print("Error performing API call: \(error)")
            notFoundError = true
        }

        spots = try await repository.getSpotsWithIDList(list: documentIds)
        calculateDistance()
    }


    
    func performAPICall(uid: String) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            backendService.performAPICall(uid: uid) { result in
                switch result {
                case .success(let spots):
                    continuation.resume(returning: spots)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
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
    
    func getUsername() async throws {
        do {
            self.uid = try await utils.getUsername()
        } catch {
            print("ERROR: Could not fetch username")
            throw NSError()
        }
    }

}
