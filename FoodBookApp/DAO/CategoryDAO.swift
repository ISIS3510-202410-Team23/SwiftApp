//
//  CategoryDAO.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/19/24.
//

import Foundation

protocol CategoryDAO {
    static var shared: CategoryDAO { get }
    func getCategories() async throws -> [String]
}
