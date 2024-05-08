//
//  SearchUsageRepository.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 7/05/24.
//

import Foundation

protocol SearchUsageRepository {
    static var searchUsageSA: SearchUsageSA {get}
    func updateSharedItems(items: [String]) async throws
}
