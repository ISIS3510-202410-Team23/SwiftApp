//
//  CacheService.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 18/04/24.
//

import Foundation

class CacheService: ObservableObject {
    static let shared = CacheService()
    
    private let spotsCache = NSCache<NSString, NSArray>()
    private let forYouCache = NSCache<NSString, NSArray>()
    
    private init() {}
    
    // MARK: - Spots Cache
    
    func setSpots(_ spots: [Spot]) {
        let nsArray = spots as NSArray
        spotsCache.setObject(nsArray, forKey: "spots")
    }

    
    
    func getSpots() -> [Spot]? {
        if let nsArray = spotsCache.object(forKey: "spots") {
            return nsArray as? [Spot]
        }
        return nil
    }

    
    // MARK: - ForYou Cache
    
    func setForYou(_ spots: [Spot]) {
        forYouCache.setObject(spots as NSArray, forKey: "fyp")
    }
    
    func getForYou() -> [Spot]? {
        return forYouCache.object(forKey: "fyp") as? [Spot]
    }

}
