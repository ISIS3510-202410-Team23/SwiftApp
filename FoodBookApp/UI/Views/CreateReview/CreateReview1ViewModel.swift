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
    
    private let categoryRepository: CategoryRepository = CategoryRepositoryImpl.shared
    private let unfinishedReviewRepository: UnfinishedReviewRepository = UnfinishedReviewRepositoryImpl.shared
    private let utils = Utils.shared
    
    @MainActor
    func fetchCategories() async throws {
        self.categories = try await categoryRepository.getCategories()
    }
    
    func increaseUnfinishedReviewCount() async throws {
        let user = try await utils.getUsername()
        try await unfinishedReviewRepository.updateUnfinishedReviewCount(user: user)
    }
}
