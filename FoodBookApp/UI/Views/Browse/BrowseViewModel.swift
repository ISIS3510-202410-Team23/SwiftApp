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
    
    func fetchSpots() async throws -> [Spot] {
//        TODO: This should read from API and append every spot to spots
//        let url = URL(string: "")!
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoder = JSONDecoder()
//        return try decoder.decode(Item.self, from: data)
        try await Task.sleep(nanoseconds: 20000)
        
        spots = [
            Spot(
                id:"1",
                categories: ["Vegan", "Homemade", "Fast", "Colombian", "Dessert"],
                location: GeoPoint(latitude: 0, longitude: 0),
                name: "MiCaserito",
                price: "$",
                waitTime:   WaitTime(min: 5, max: 10),
                reviewData: ReviewData(stats: SpotStats(cleanliness: 5, foodQuality: 5, service: 5, waitTime: 5), userReviews: []),
                imageLinks: [
                    "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2380&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1493770348161-369560ae357d?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1498837167922-ddd27525d352?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1473093295043-cdd812d0e601?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                    
                ]
            ),
            
            Spot(
                id: "id-2",
                categories: ["Vegan", "Sandwich", "Bowl", "Healthy", "..."],
                location: GeoPoint(latitude: 0, longitude: 0),
                name: "Divino Pecado",
                price: "$$",
                waitTime:   WaitTime(min: 25, max: 30),
                reviewData: ReviewData(stats: SpotStats(cleanliness: 5, foodQuality: 5, service: 5, waitTime: 5), userReviews: []),
                imageLinks: [
                    "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2380&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1493770348161-369560ae357d?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1498837167922-ddd27525d352?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1473093295043-cdd812d0e601?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    "https://images.unsplash.com/photo-1529042410759-befb1204b468?q=80&w=2486&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                ]
            )
        ]
        return spots
    }
    
}
