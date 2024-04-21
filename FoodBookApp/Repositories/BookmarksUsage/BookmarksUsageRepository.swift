//
//  BookmarksUsageRepository.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/20/24.
//

import Foundation

protocol BookmarksUsageRepository {
    static var bookmarksUsageSA: BookmarksUsageSA { get }
    func updateBookmarksUsage(usage:Bool) async throws
}
