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
        }
    }
    
    func containsId(spotId: String) -> Bool {
        return savedBookmarkIds.contains(spotId)
    }
}
