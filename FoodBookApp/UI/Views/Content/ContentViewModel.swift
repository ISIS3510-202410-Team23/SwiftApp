//
//  ContentViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 16/04/24.
//

import Foundation
import CoreData
import FirebaseFirestore

@Observable
class ContentViewModel {
    static let shared = ContentViewModel()
    
    private init() {}
    
    var spots: [Spot] = []
    var forYouSpots: [Spot] = []
    var noReviewsFlag: Bool = false
    
    var uid: String = ""
    var dids: [String] = []
    
    private let locationService = LocationService.shared
    private let locationUtils = LocationUtils()
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    private let backendService: BackendService = BackendService.shared
    private let cacheService: CacheService = CacheService.shared
    private let utils = Utils.shared
    
    
    func fetch() async throws {
        await withTaskGroup(of: Void.self) { group in
            group.addTask() {
                do {
                    self.spots = try await self.fetchSpots()
                    await self.calculateDistance()
                    self.cacheService.setSpots(self.spots)
                    
                } catch {
                    print("ERROR: fetching spots from firebase \(error)")
                }
            }
            
            group.addTask() {
                do {
                    self.uid = try await self.getUsername()
                    self.dids = try await self.performAPICall(uid: self.uid)
                    self.forYouSpots = try await self.fetchSpotsWithIDList(li: self.dids)
                    await self.calculateDistanceForYou()
                    self.cacheService.setForYou(self.forYouSpots)
                    
                } catch {
                    print("ERROR: fetching backend \(error)")
                }
            }
            
            await group.waitForAll()
        }
    }
    
    func fallback() {
        
        self.spots = cacheService.getSpots() ?? []
        self.forYouSpots = cacheService.getForYou() ?? []

    }

    

    
    // MARK: - Fetching functions
    
    private func fetchSpots() async throws -> [Spot] {
        return try await repository.getSpots()
    }
    
    private func fetchSpotsWithIDList(li: [String]) async throws -> [Spot] {
        if li == ["404"] {
            self.noReviewsFlag = true
            return []
        } else {
            self.noReviewsFlag = false
            return try await repository.getSpotsWithIDList(list: li)
        }
    }
    
    private func performAPICall(uid: String) async throws -> [String] {
        do {
            return try await backendService.performAPICall(uid: uid)
        } catch {
            print("ContentViewModel: Error performing API call: \(error)")
            throw error
        }
    }
    
    private func getUsername() async throws -> String {
        do {
            return try await utils.getUsername()
        } catch {
            print("ERROR: Could not fetch username")
            throw error
        }
    }
    
    // I know this code is repeated, i just dont know the best way to separate it so i'll leave like this for now
    
    private func calculateDistance() async {
        for index in self.spots.indices {
            spots[index].distance = locationUtils.calculateDistance(
                fromLatitude: spots[index].location.latitude,
                fromLongitude: spots[index].location.longitude,
                toLatitude: locationService.userLocation?.coordinate.latitude ?? 0,
                toLongitude: locationService.userLocation?.coordinate.longitude ?? 0)
        }
    }
    
    private func calculateDistanceForYou() async {
        for index in self.forYouSpots.indices {
            forYouSpots[index].distance = locationUtils.calculateDistance(
                fromLatitude: spots[index].location.latitude,
                fromLongitude: spots[index].location.longitude,
                toLatitude: locationService.userLocation?.coordinate.latitude ?? 0,
                toLongitude: locationService.userLocation?.coordinate.longitude ?? 0)
        }
    }
}
