//
//  CategorySA.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/19/24.
//

import Foundation

protocol CategorySA {
    static var shared: CategorySA { get }
    func getCategories() async throws -> [String]
}
