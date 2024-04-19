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
    private let didsCache = NSCache<NSString, NSString>()
    private let uidCache = NSCache<NSString, NSString>()
    
    private init() {}
    
    // MARK: - Spots Cache
    
    func setSpots(_ spots: [Spot]) {
        spotsCache.setObject(spots as NSArray, forKey: "spots")
    }
    
    func getSpots() -> [Spot]? {
        return spotsCache.object(forKey: "spots") as? [Spot]
    }
    
    // MARK: - Dids Cache
    
    func setDids(_ dids: [String]) {
        didsCache.setObject(dids[0] as NSString, forKey: "dids")
    }
    
    func getDids() -> [String]? {
        if let did = didsCache.object(forKey: "dids") {
            return [did as String]
        }
        return nil
    }
    
    // MARK: - UID Cache
    
    func setUID(_ uid: String) {
        uidCache.setObject(uid as NSString, forKey: "uid")
    }
    
    func getUID() -> String? {
        return uidCache.object(forKey: "uid") as String?
    }
}
