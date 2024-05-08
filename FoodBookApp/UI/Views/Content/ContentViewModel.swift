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
    
    var browseSpots: [Spot] = HardcodedSpots.shared.spots
    var forYouSpots: [Spot] = []
    
    var browseSpotsCached: [Spot] = HardcodedSpots.shared.spots
    var forYouSpotsCached: [Spot] = []
    
    var noReviewsFlag: Bool = false
    
    var uid: String = ""
    var dids: [String] = []
    
    private let locationService = LocationService.shared
    private let locationUtils = LocationUtils()
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    private let searchRepository: SearchUsageRepository = SearchUsageRepositoryImpl.shared
    private let backendService: BackendService = BackendService.shared
    private let cacheService: CacheService = CacheService.shared
    private let utils = Utils.shared
    
    private let fileURL: URL = {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsDirectory.appendingPathComponent("inputHistory.json")
        }()
    
    
    func fetch() async throws {
        await withTaskGroup(of: Void.self) { group in
            
            group.addTask() {
                do {
                    self.uid = try await self.getUsername()
                    self.dids = try await self.performAPICall(uid: self.uid)
                    self.forYouSpots = try await self.fetchSpotsWithIDList(li: self.dids)
                    await self.calculateDistanceForYou()
                    self.cacheService.setForYou(self.forYouSpots)
                    self.forYouSpotsCached = self.forYouSpots
                    
                } catch {
                    print("ERROR: fetching backend \(error)")
                }
            }
            
            group.addTask() {
                do {
//                    print("SPOTS: Before fetch: \(self.browseSpots.count)")
                    self.browseSpots = try await self.fetchSpots()
//                    print("SPOTS: After fetch: \(self.browseSpots.count)")
                    await self.calculateDistance()
                    if self.browseSpots != [] && !self.browseSpots.isEmpty && self.browseSpots.count != 0 {
//                        print("SPOTS: Before setting cache: \(self.browseSpots.count)")
                        self.cacheService.setSpots(self.browseSpots)
                        self.browseSpotsCached = self.browseSpots //this one (delete!)
//                        print("SPOTS: After setting cache: \(self.browseSpots.count)")
                    }
                    
                } catch {
                    print("ERROR: fetching spots from firebase \(error)")
                }
            }
            
            
            await group.waitForAll()
        }
    }
    
    func fallback() {
//        print("SPOTS: Before fallback: \(self.browseSpots.count)")
        self.browseSpotsCached = cacheService.getSpots() ?? HardcodedSpots.shared.spots
//        print("SPOTS: After fallback: \(self.browseSpots.count)")
        self.forYouSpotsCached = cacheService.getForYou() ?? []

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
    
//    MARK: - Calculation functions
    
    private func calculateDistance() async {
//        print("SPOTS: Before calculating distance: \(self.browseSpots.count)")
        for index in self.browseSpots.indices {
            browseSpots[index].distance = locationUtils.calculateDistance(
                fromLatitude: browseSpots[index].location.latitude,
                fromLongitude: browseSpots[index].location.longitude,
                toLatitude: locationService.userLocation?.coordinate.latitude ?? 0,
                toLongitude: locationService.userLocation?.coordinate.longitude ?? 0)
        }
//        print("SPOTS: After calculating distance: \(self.browseSpots.count)")
    }
    
    private func calculateDistanceForYou() async {
        for index in self.forYouSpots.indices {
            forYouSpots[index].distance = locationUtils.calculateDistance(
                fromLatitude: forYouSpots[index].location.latitude,
                fromLongitude: forYouSpots[index].location.longitude,
                toLatitude: locationService.userLocation?.coordinate.latitude ?? 0,
                toLongitude: locationService.userLocation?.coordinate.longitude ?? 0)
        }
    }
    
    // MARK: - Search history
    
    func loadInputHistory() -> [String] {
        if let data = try? Data(contentsOf: fileURL),
           let history = try? JSONDecoder().decode([String].self, from: data) {
            return history
        }
        return []
    }
    
    func writeInputHistory(inputHistory: [String]) throws {
        if let data = try? JSONEncoder().encode(inputHistory) {
            try? data.write(to: fileURL)
        }
    }
    
    func saveSearchItems(items: [String]) async throws{
        do {
            try await searchRepository.updateSharedItems(items: items)
        } catch {
            print("Error saving search items \(error)")
        }
    }
    
}
