//
//  BookmarksUsageSA.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/20/24.
//

import Foundation

protocol BookmarksUsageSA {
    static var shared: BookmarksUsageSA { get }
    func updateBookmarksUsage(userId: String, usage: Bool) async throws
}
