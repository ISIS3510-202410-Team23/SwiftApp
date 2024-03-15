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
                        reviewData: ReviewData(stasts: SpotStats(cleanliness: 5, foodQuality: 4, service: 3, waitTime: 2), userReviews: [
                            Review(
                                content: "Lo digo y lo insisto, mi caserito es el restaurante más completo de los andes.",
                                date: Date(),
                                imageUrl: "https://i.ytimg.com/vi/1n6bq4wfoSU/hq720.jpg?sqp=-oaymwEXCK4FEIIDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLCCW-rqYpxNt3xW3Ag43ns--EwGLw",
                                ratings: ReviewStats(cleanliness: 5, foodQuality: 5, service: 5, waitTime: 4),
                                selectedCategories: ["Homemade", "Dessert"],
                                title: "Me fascina!!",
                                user: "Juan Pedro Gonzalez" // TODO: will be user uid, might need to add antoher field for email
                            ),
                            Review(
                                content: "La comida me gustó pero la atención fue pésima, se demoró muchísimo, lástima.",
                                date: Date(),
                                imageUrl: nil,
                                ratings: ReviewStats(cleanliness: 2,
                                                   foodQuality: 3,
                                                   service: 1,
                                                   waitTime: 1),
                                
                                    selectedCategories: ["Poultry", "Rice", "Soup"],
                                    title: "No lo recomiendo.",
                                    user: "Mariana Martínez"
                            )
                            
                        ]),
                        imageLinks: nil
                )

        return spot
    }
}
