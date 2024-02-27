//
//  BrowseViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 26/02/24.
//
import Observation
import Foundation

@Observable
class BrowseViewModel {
    var spots: [Spot] = []
    
    func fetchSpots() async throws -> [Spot] {
//        TODO: This should read from API and append every spot to spots
//        let url = URL(string: "")!
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoder = JSONDecoder()
//        return try decoder.decode(Item.self, from: data)
        var spots: [Spot] = []
        spots.append(
            Spot(
                name: "Mi Caserito",
                minTime: 10,
                maxTime: 20,
                distance: 0.3,
                categories: ["Fast", "Homemade", "Colombian", "..."]
            ))
        spots.append(
            Spot(
                name: "Divino Pecado",
                minTime: 25,
                maxTime: 30,
                distance: 0.5,
                categories: ["Vegan", "Sandwich", "Bowl", "Healthy", "..."]
            ))
        return spots
    }
    
}
