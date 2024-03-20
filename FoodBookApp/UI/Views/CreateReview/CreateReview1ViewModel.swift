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
    
    private let repository: CategoryRepository = CategoryRepositoryImpl.shared
    
    @MainActor
    func fetchCategories() async throws {
        self.categories = try await repository.getCategories().map { tag in
            tag.capitalized
        }
    }
}
