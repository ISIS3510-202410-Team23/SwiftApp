//
//  SearchUsageSA.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 7/05/24.
//

import Foundation

protocol SearchUsageSA {
    static var shared: SearchUsageSA { get }
    func updateSharedItems(items: [String]) async throws
}
