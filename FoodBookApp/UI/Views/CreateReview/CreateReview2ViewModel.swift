//
//  CreateReview2ViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import Observation

@Observable
class CreateReview2ViewModel {
    private let repository: ReviewRepository = ReviewRepositoryImpl.shared
    var username: String = ""
    
    init() {}
    
    @MainActor
    func addReview(review: Review) async throws -> String {
            do {
                let id = try await repository.createReview(review: review)
                return id
            } catch {
                throw error
            }
    }
    
    func getUsername() async throws {
        do {
            let email = try await AuthService.shared.getAuthenticatedUser().email
            if let email = email {
                let usernameComponents = email.split(separator: "@")
                if let username = usernameComponents.first {
                    self.username = String(username)
                } else {
                    throw NSError(domain: "YourDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid email format"])
                }
            } else {
                throw NSError(domain: "YourDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email not found"])
            }
        } catch {
            throw error
        }
    }

     
}
