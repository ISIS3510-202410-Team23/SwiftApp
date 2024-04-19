//
//  ContentViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 16/04/24.
//

import Foundation
import CoreData
import FirebaseFirestore

class ContentViewModel {
    var spots: [Spot] = []
    private var uid: String = ""
    private var dids: [String] = []
    
    private let locationService = LocationService.shared
    private let locationUtils = LocationUtils()
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    private let backendService: BackendService = BackendService.shared
    private let cacheService: CacheService = CacheService.shared
    private let utils = Utils.shared
    
    
    func networkFallbackToCache() async throws {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                do {
                    if let cachedSpots = self.cacheService.getSpots() {
                        self.spots = cachedSpots
                    } else {
                        self.spots = try await self.fetchSpots()
                        self.cacheService.setSpots(self.spots)
                    }
                    
                    await self.calculateDistance()
                    print("DEBUG: Spots from model: \(self.spots)")
                } catch {
                    print("ERROR: fetching spots from firebase \(error)")
                }
            }
            
            group.addTask {
                do {
                    if let cachedUid = self.cacheService.getUID() {
                        self.uid = cachedUid
                    } else {
                        self.uid = try await self.getUsername()
                        self.cacheService.setUID(self.uid)
                    }
                    
                    if let cachedDids = self.cacheService.getDids() {
                        self.dids = cachedDids
                    } else {
                        self.dids = try await self.performAPICall(uid: self.uid)
                        self.cacheService.setDids(self.dids)
                    }
                    
                    print("DEBUG: Dids from model: \(self.dids)")
                    
                } catch {
                    print("ERROR: fetching backend \(error)")
                }
            }
        }
    }
    
    
    
    private func fetchSpots() async throws -> [Spot] {
        return try await repository.getSpots()
    }
    
    private func performAPICall(uid: String) async throws -> [String] {
        do {
            return try await backendService.performAPICall(uid: uid)
        } catch {
            print("ContentViewModel: Error performing API call: \(error)")
            throw error // Throw the original error for better context
        }
    }
    
    private func getUsername() async throws -> String {
        do {
            return try await utils.getUsername()
        } catch {
            print("ERROR: Could not fetch username")
            throw error // Throw the original error for better context
        }
    }
    
    private func calculateDistance() async {
        for index in spots.indices {
            spots[index].distance = locationUtils.calculateDistance(
                fromLatitude: spots[index].location.latitude,
                fromLongitude: spots[index].location.longitude,
                toLatitude: locationService.userLocation?.coordinate.latitude ?? 0,
                toLongitude: locationService.userLocation?.coordinate.longitude ?? 0)
        }
    }
}
