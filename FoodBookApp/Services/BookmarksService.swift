//
//  BookmarksService.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/17/24.
//

import Foundation

@Observable
final class BookmarksService {
    
    static let shared: BookmarksService = BookmarksService()
    static let bookmarksCache = NSCache<NSString, NSArray>()
    private let cacheKey: NSString = "BookmarksInfo"
    var savedBookmarkIds: Set<String> = []
    
    private init() {
        self.savedBookmarkIds = self.loadBookmarksIds()
    }
    
    private func loadBookmarksIds() -> Set<String> {
        if let bookmarksArray = UserDefaults.standard.array(forKey: "bookmarks") as? [String] {
            return Set(bookmarksArray)
        }
        return []
    }
    
    func updateBookmarks(spotId: String) {
        if !self.containsId(spotId: spotId) {
            self.savedBookmarkIds.insert(spotId)
        } else {
            self.savedBookmarkIds.remove(spotId)
            
            // Remove from cache
            if self.noBookmarks() { // None left, remove reference
                BookmarksService.bookmarksCache.removeObject(forKey: cacheKey)
            } else { // Remove specific instance
                if let cachedSpots = BookmarksService.bookmarksCache.object(forKey: cacheKey) {
                    var spots = cachedSpots as! [Spot]
                    spots.removeAll(where: {$0.id == spotId})
                    BookmarksService.bookmarksCache.setObject(spots as NSArray, forKey: cacheKey) // Updated List
                }
            }
        }
        
        print("Now there are \(savedBookmarkIds.count) saved.")
        UserDefaults.standard.set(Array(self.savedBookmarkIds), forKey: "bookmarks")
    }
    
    func containsId(spotId: String) -> Bool {
        return savedBookmarkIds.contains(spotId)
    }
    
    func noBookmarks() -> Bool {
        return self.savedBookmarkIds.isEmpty
    }
}
