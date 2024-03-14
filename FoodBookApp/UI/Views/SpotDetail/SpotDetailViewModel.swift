//
//  SpotDetailViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import Observation
import FirebaseFirestore //FIXME: delete later

@Observable
class SpotDetailViewModel {
    
    var spot = Spot (
           id: "",
           categories: [""],
           location: GeoPoint(latitude: 0, longitude: 0),
           name: "",
           price: "",
           waitTime: WaitTime(min: 0, max: 0),
           reviewData: nil,
           imageLinks: nil
       )

    
    func fetchSpot() async throws -> Spot { // FIXME: should receive spot's ID
        // TODO: actual fetch
        try await Task.sleep(nanoseconds: 20000)
        spot = Spot(
                        id:"1",
                        categories: ["Vegan", "Homemade", "Fast", "Colombian", "Dessert"],
                        location: GeoPoint(latitude: 0, longitude: 0),
                        name: "MiCaserito",
                        price: "$",
                        waitTime:   WaitTime(min: 5, max: 10),
                        reviewData: nil,
                        imageLinks: nil
                )

        return spot
    }
}
