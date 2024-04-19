//
//   swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/18/24.
//

import Foundation

// Temp
import FirebaseFirestore

@Observable
final class BookmarksViewModel {
    
    var spots: [Spot] = []
    var noBookmarks = {
        BookmarksService.shared.noBookmarks()
    }
    
    private let cacheKey: NSString = "BookmarksInfo"
    
    private let bookmarksManager = BookmarksService.shared
    private let bookmarksCache = BookmarksService.bookmarksCache
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    
    func fetchSpots() async {
        print("Fetching bookmarked spots...")
        
        if let cachedSpots = bookmarksCache.object(forKey: cacheKey) {
            print("Bookmarks loaded from cache")
            spots = cachedSpots as! [Spot]
        } else {
            do {
                spots = try await self.repository.getSpotsWithIDList(list: Array(bookmarksManager.savedBookmarkIds))
                 bookmarksCache.setObject(spots as NSArray, forKey: cacheKey)
            } catch {
                print(error)
            }
        }
        
    }
}
