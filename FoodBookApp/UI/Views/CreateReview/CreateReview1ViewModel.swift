//
//  CreateReview1ViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import Observation

@Observable
class CreateReview1ViewModel {
    var categories: [String] = []
    
    func fetchCategories() async throws -> [String] {
        // TODO: actual fetch
        try await Task.sleep(nanoseconds: 20000)
        
        categories = ["Vegan", "Italian", "Fast", "Healthy", "Homemade", "Poultry", "Meat", "Dessert",
                      "Vegetarian", "Gluten-free", "Low-carb", "Salad", "Fruit", "Organic", "Coffee", "Dairy-free",
                      "Thailandese", "Asian", "Colombian", "Kosher", "Chocolate", "Traditional", "Beef", "Group-portion",
                      "Spicy", "Japanese", "Sushi", "Poke", "Chinese", "Rice", "Noodles", "Burger", "Fries", "Sandwich",
                      "Bowl", "Candy", "Pizza"]
        
        return categories
        
    }
}
