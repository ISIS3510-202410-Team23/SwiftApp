//
//  UserReviewsViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 13/05/24.
//

import Foundation
import Observation

@Observable
class UserReviewsViewModel {
    
    private let cacheService = CacheService.shared
    var userReviews: [Review] = []
    
    private let reviewRepository: ReviewRepository = ReviewRepositoryImpl.shared
    
    func fetchUserReviews(username: String, userId: String, name: String) async throws {
        if let cachedReviews = cacheService.getReviewsCache(userId: userId) {
            print("Reviews loaded from cache for \(userId)")
            userReviews = cachedReviews.sorted { $0.date > $1.date } // Sort by date
        } else {
            do {
                if NetworkService.shared.isOnline {
                    print("Fetching reviews from firebase for \(name)-\(username)...")
                    userReviews = try await self.reviewRepository.getUserReviews(name: name, username: username)
                    if !userReviews.isEmpty {
                        cacheService.setReviewsCache(userReviews, userId: userId)
                    }
                    userReviews = userReviews.sorted { $0.date > $1.date } // Sort by date
                } else {
                    print("No cache nor network...")
                }
            } catch {
                print("[User Reviews] Fetching error: \(error)")
            }
        }
    }
}
