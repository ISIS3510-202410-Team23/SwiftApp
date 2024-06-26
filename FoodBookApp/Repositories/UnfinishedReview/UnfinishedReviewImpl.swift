//
//  UnfinishedReviewImpl.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 16/04/24.
//

import Foundation
import SwiftUI

class UnfinishedReviewRepositoryImpl: UnfinishedReviewRepository {
    static var shared: UnfinishedReviewRepository = UnfinishedReviewRepositoryImpl()
    static var unfinishedReviewSA: UnfinishedReviewSA = UnfinishedReviewSAFirebase.shared
    
    func updateUnfinishedReviewCount(spotId: String, spotName: String) async throws {
        return try await UnfinishedReviewRepositoryImpl.unfinishedReviewSA.updateUnfinishedReviewCount(spotId: spotId, spotName: spotName)
    }
}
