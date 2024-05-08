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
    
    private let unfinishedReviewRepository: UnfinishedReviewRepository = UnfinishedReviewRepositoryImpl.shared
    private let utils = Utils.shared
    
    @MainActor
    
    func increaseUnfinishedReviewCount(spotId: String, spotName: String) async throws {
        try await unfinishedReviewRepository.updateUnfinishedReviewCount(spotId: spotId, spotName: spotName)
    }
}
