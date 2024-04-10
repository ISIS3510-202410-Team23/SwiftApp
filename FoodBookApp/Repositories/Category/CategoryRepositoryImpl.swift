//
//  CategoryRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/19/24.
//

import Foundation

class CategoryRepositoryImpl: CategoryRepository {
    static var shared: CategoryRepository = CategoryRepositoryImpl()
    private static var categorySA: CategorySA = CategorySAFirebase.shared
    
    func getCategories() async throws -> [String] {
        return try await CategoryRepositoryImpl.categorySA.getCategories()
    }
    
    
}
