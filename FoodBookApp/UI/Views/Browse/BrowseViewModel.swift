//
//  BrowseViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 26/02/24.
//
import Observation
import Foundation
import CoreLocation
import FirebaseFirestore //FIXME: delete later

@Observable
class BrowseViewModel {
    var spots: [Spot] = []
    
    private let repository: SpotRepository = SpotRepositoryImpl.shared
    
    func fetchSpots() async throws -> [Spot] {
        spots = try await repository.getSpots()
        return spots
    }
    
}
