//
//  BookmarksUsageRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/20/24.
//

import Foundation

class BookmarksUsageRepositoryImpl: BookmarksUsageRepository {
    static var shared: BookmarksUsageRepositoryImpl = BookmarksUsageRepositoryImpl()
    static var bookmarksUsageSA: BookmarksUsageSA = BookmarksUsageSAFirebase.shared
    
    private var networkManager: NetworkService = NetworkService.shared
    
    func updateBookmarksUsage(usage: Bool) async throws {
        do {
            let userId = try await Utils.shared.getUsername()
            try await BookmarksUsageRepositoryImpl.bookmarksUsageSA.updateBookmarksUsage(userId: userId, usage: usage)
        } catch {
            print(error)
        }
    }
    
    
}
