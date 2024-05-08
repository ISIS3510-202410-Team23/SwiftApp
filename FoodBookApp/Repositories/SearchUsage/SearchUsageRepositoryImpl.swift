//
//  SearchUsageRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 7/05/24.
//

import Foundation

class SearchUsageRepositoryImpl: SearchUsageRepository {
    static var shared: SearchUsageRepositoryImpl = SearchUsageRepositoryImpl()
    static var searchUsageSA: SearchUsageSA = SearchUsageSAFirebase.shared
    
    func updateSharedItems(items: [String]) async throws {
        do {
            try await SearchUsageRepositoryImpl.searchUsageSA.updateSharedItems(items: items)
        } catch {
            print(error)
        }
    }
}
