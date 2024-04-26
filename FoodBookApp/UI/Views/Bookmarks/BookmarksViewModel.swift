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
    private let cacheKey: NSString = "BookmarksInfo"
    
    private let bookmarksCache = BookmarksService.bookmarksCache
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    
    func fetchSpots(_ spotIds: [String]) async {
        print("Fetching bookmarked spots...")
        
        if let cachedSpots = bookmarksCache.object(forKey: cacheKey) {
            print("Bookmarks loaded from cache")
            spots = cachedSpots as! [Spot]
        } else {
            do {
                if NetworkService.shared.isOnline {
                    print("Fetching from firebase...")
                    spots = try await self.repository.getSpotsWithIDList(list: spotIds)
                    if !spots.isEmpty {
                        bookmarksCache.setObject(spots as NSArray, forKey: cacheKey)
                    }
                }
            } catch {
                print("[Bookmarks] Fetching error: ", error)
            }
        }
        
    }
}
