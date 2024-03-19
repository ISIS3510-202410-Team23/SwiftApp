//
//  CategoryRepository.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/19/24.
//

import Foundation

protocol CategoryRepository {
    
    func getCategories() async throws -> [String]
}
