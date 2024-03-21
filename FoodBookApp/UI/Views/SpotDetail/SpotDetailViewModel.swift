//
//  SpotDetailViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
class SpotDetailViewModel {
    
    
    var spot: Spot = Spot(categories: [], location: GeoPoint(latitude: 0, longitude: 0), name: "", price: "", waitTime: WaitTime(min: 0, max: 5), reviewData: ReviewData(stats: SpotStats(cleanliness: 5, foodQuality: 5, service: 5, waitTime: 5), userReviews: []), imageLinks: [])
    
    var ratings: [String: Double] = ["Cleanliness": 0, "Waiting time": 0, "Service": 0, "Food quality": 0]
    
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    
    init() {}
    
    @MainActor
    func fetchSpot(spotId: String) async throws {
        self.spot = try await repository.getSpotById(docId: spotId)
        self.ratings = ["Cleanliness": self.spot.reviewData.stats.cleanliness / 5,"Waiting Time": self.spot.reviewData.stats.waitTime / 5,"Service": self.spot.reviewData.stats.service / 5,"Food quality": self.spot.reviewData.stats.foodQuality / 5]
    }
}
