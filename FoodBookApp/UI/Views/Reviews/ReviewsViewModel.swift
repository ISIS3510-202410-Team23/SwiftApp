//
//  ReviewsViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 13/05/24.
//

import Foundation
import Observation

@Observable
class ReviewsViewModel {
    private let utils = Utils.shared
    var username: String = ""
    var user: String?
    
    init() {}
    
    func getUserInfo() async throws {
        self.username = try await utils.getUsername()
        self.user = try await utils.getUser()
    }
}
