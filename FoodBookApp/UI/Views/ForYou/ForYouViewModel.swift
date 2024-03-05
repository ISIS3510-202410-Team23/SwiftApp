//
//  ForYouViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 29/02/24.
//

import Observation
import Foundation
import CoreLocation

@Observable
class ForYouViewModel {
    var spots: [Spot] = []
    
    func fetchRecommendedSpots(uid:String) async throws -> [Spot] {
//        TODO: This should read from API and append every spot to spots
        try await Task.sleep(nanoseconds: 20000)
        
        spots = [
            Spot(
                id: "id-3",
                name: "Gratto",
                minTime: 5,
                maxTime: 10,
                distance: 0.3,
                latitude: 0.0,
                longitude: 0.0,
                categories: ["Coffee", "Pastry", "Snack", "..."]
            ),
            
            Spot(
                id: "id-4",
                name: "Happy Snacks",
                minTime: 25,
                maxTime: 30,
                distance: 0.5,
                latitude: 0.0,
                longitude: 0.0,
                categories: ["Vegan", "Salad", "Bowl", "Healthy", "..."]
            )
        ]
        return spots
    }
    
}
