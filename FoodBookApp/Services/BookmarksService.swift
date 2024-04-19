//
//  BookmarksService.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/17/24.
//

import Foundation

@Observable
final class BookmarksService {
    
    var savedBookmarkIds: Set<String> = []
    var user: AuthDataResultModel? {
        do {
            return try AuthService.shared.getAuthenticatedUser()
        } catch {
            return nil
        }
    }
    
    init() {
        self.savedBookmarkIds = self.loadBookmarksIds()
    }
    
    private func loadBookmarksIds() -> Set<String> {
        if let bookmarksArray = UserDefaults.standard.array(forKey: "bookmarks-\(user?.uid ?? "defaut")") as? [String] {
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
        
        UserDefaults.standard.set(Array(self.savedBookmarkIds), forKey: "bookmarks-\(user?.uid ?? "defaut")")
 
    }
    
    func containsId(spotId: String) -> Bool {
        return savedBookmarkIds.contains(spotId)
    }
}
