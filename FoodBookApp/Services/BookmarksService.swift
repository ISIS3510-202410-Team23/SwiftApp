//
//  BookmarksService.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/17/24.
//

import Foundation

@Observable
final class BookmarksService {
    
    
    static let bookmarksCache = NSCache<NSString, NSArray>()
    private let cacheKey: NSString = "BookmarksInfo"
    
    private let repository: BookmarksUsageRepository = BookmarksUsageRepositoryImpl.shared
    private var savedBookmarkIds: Set<String> = []
    var user: AuthDataResultModel? {
        do {
            return try AuthService.shared.getAuthenticatedUser()
        } catch {
            return nil
        }
    }
    
    init() {
        self.loadBookmarksIds()
    }
    
    private func loadBookmarksIds() {
        print("[INFO] Loading bookmarks for \(user?.uid ?? "default")")
        if let bookmarksArray = UserDefaults.standard.array(forKey: "bookmarks-\(user?.uid ?? "defaut")") as? [String] {
            self.savedBookmarkIds =  Set(bookmarksArray)
        } else {
            self.savedBookmarkIds = Set()
        }
        print("[INFO] Loaded \(self.savedBookmarkIds.count) ids for \(user?.uid ?? "default")")
    }
    
    func updateBookmarks(spot: Spot) {
        let spotId = spot.id ?? ""
        let prevSize = savedBookmarkIds.count
        var insert = true
        
        // MARK: update local storage
        
        if !self.containsId(spotId: spotId) {
            self.savedBookmarkIds.insert(spotId)
        } else {
            self.savedBookmarkIds.remove(spotId)
            insert = false
        }
        
        // MARK: update cache
        if self.noBookmarks() { // None left, remove reference
            self.clearCache()
        } else { // Remove specific instance
            updateCache(spot: spot, insert: insert)
        }
        
        
        print("[INFO] Now there are \(savedBookmarkIds.count) saved for \(user?.uid ?? "defaut").")
        UserDefaults.standard.set(Array(self.savedBookmarkIds), forKey: "bookmarks-\(user?.uid ?? "defaut")")
        
        if prevSize == 0 && savedBookmarkIds.count - prevSize == 1 {
            updateUserLogs(usage: true)
        } else if prevSize == 1 && savedBookmarkIds.count - prevSize == -1 {
            updateUserLogs(usage: false)
        }
    }
    
    func getBookmarks () -> [String] {
        return Array(self.savedBookmarkIds)
    }
    
    func containsId(spotId: String) -> Bool {
        return savedBookmarkIds.contains(spotId)
    }
    
    func noBookmarks() -> Bool {
        return self.savedBookmarkIds.isEmpty
    }
    
    func updateUserLogs(usage usesBookmarks: Bool)  {
        Task(priority: .background) {
            try await self.repository.updateBookmarksUsage(usage: usesBookmarks)
        }
    }
    
    func updateCache(spot: Spot, insert: Bool) {
        if let cachedSpots = BookmarksService.bookmarksCache.object(forKey: cacheKey) {
            var spots = cachedSpots as! [Spot]
            
            if insert {
                spots.append(spot)
            } else {
                spots.removeAll(where: {$0.id == spot.id ?? ""})
            }
            
            BookmarksService.bookmarksCache.setObject(spots as NSArray, forKey: cacheKey) // Updated List
        }
    }
    
    func cleanup() {
        self.clearCache()
        self.savedBookmarkIds = Set()
    }
    
    private func clearCache() {
        BookmarksService.bookmarksCache.removeObject(forKey: cacheKey)
    }
}
