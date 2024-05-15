//
//  CacheService.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 18/04/24.
//

import Foundation

@Observable
class CacheService {
    static let shared = CacheService()
    
    private let spotsCache = NSCache<NSString, NSArray>()
    private let forYouCache = NSCache<NSString, NSArray>()
    
    private let reviewsCache = NSCache<NSString, NSArray>()
    
    private init() {}
    
    // MARK: - Spots Cache
    
    func setSpots(_ spots: [Spot]) {
        if !spots.isEmpty {
            let nsArray = spots as NSArray
            spotsCache.setObject(nsArray, forKey: "spots")
            print("SPOTS have been set to: \(spots.count)")
        }
    }

    
    
    func getSpots() -> [Spot]? {
        return spotsCache.object(forKey: "spots") as? [Spot]
    }

    
    // MARK: - ForYou Cache
    
    func setForYou(_ spots: [Spot]) {
        forYouCache.setObject(spots as NSArray, forKey: "fyp")
    }
    
    func getForYou() -> [Spot]? {
        return forYouCache.object(forKey: "fyp") as? [Spot]
    }
    
    func setReviewsCache(_ reviews: [Review], userId: String) {
        if !reviews.isEmpty {
            let nsArr = reviews as NSArray
            reviewsCache.setObject(nsArr, forKey: "\(userId)-reviews" as NSString)
            print("REVIEWS for \(userId) have been set to: \(reviews.count)")
        }
    }
    
    func getReviewsCache(userId: String) -> [Review]? {
        return reviewsCache.object(forKey: "\(userId)-reviews" as NSString) as? [Review]
    }

}
