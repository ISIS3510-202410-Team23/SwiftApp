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
//    var notFoundError = false
    
    private let backendService = BackendService.shared
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    private let locationService = LocationService.shared
    private let locationUtils = LocationUtils()
    private let cacheService: CacheService = CacheService.shared
    private let utils = Utils.shared
    
    func fetchRecommendedSpots() async throws {
        do {
            try await getUsername()
            let dids = try await performAPICall(uid: self.uid)
            
            if dids != [""] && !dids.isEmpty {
                self.spots = try await repository.getSpotsWithIDList(list: dids)
                calculateDistance()
            }
        } catch {
            if let urlError = error as? URLError, urlError.code == .cancelled {
                print("API call was cancelled")
            } else {
//                print("Error performing API call: \(error)")
                throw NSError()
            }
        }
    }
    
    
    
    func performAPICall(uid: String) async throws -> [String] {
        do {
            return try await backendService.performAPICall(uid: uid)
        } catch {
            print("ForYouViewModel: Error performing API call: \(error)")
            throw NSError()
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
