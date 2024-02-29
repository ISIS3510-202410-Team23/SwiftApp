//
//  SpotDetailViewModelpo.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import Observation

@Observable
class SpotDetailViewModel {
    
    var spot = Spot(
        id: "",
        name: "",
        minTime: 0,
        maxTime: 0,
        distance: 0,
        latitude: 0,
        longitude: 0,
        categories: [""]
    )
    
    func fetchSpot() async throws -> Spot { // FIXME: should receive spot's ID
        // TODO: actual fetch
        try await Task.sleep(nanoseconds: 20000)
        spot = Spot(id:"1",
                name: "MiCaserito",
                minTime: 5,
                maxTime: 10,
                distance: 0.5,
                latitude: 4.663883085700034,
                longitude: -74.08049675792543,
                categories: ["Vegan", "Homemade", "Fast", "Colombian", "Dessert"])
        return spot
    }
}
