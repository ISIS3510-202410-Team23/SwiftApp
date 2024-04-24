//
//  SpotInfo.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 23/04/24.
//

import Foundation
import FirebaseFirestore

class HardcodedSpots {
    static let shared = HardcodedSpots()
    
    private init() {}
    
    var spots: [Spot] = [
        Spot(id: "7kzd8gmyG842rx2Ad98b",
             categories: [
                Category(name: "vegan", count: 5),
                Category(name: "fruit", count: 1),
                Category(name: "salad", count: 2),
                Category(name: "healthy", count: 1),
                Category(name: "vegetarian", count: 4),
                Category(name: "asian", count: 1),
                Category(name: "low-carb", count: 1),
                Category(name: "sushi", count: 1),
                Category(name: "colombian", count: 1),
                Category(name: "beef", count: 1),
                Category(name: "italian", count: 1),
                Category(name: "noodles", count: 1),
                Category(name: "gluten-free", count: 1),
                Category(name: "snack", count: 1),
                Category(name: "poultry", count: 1),
                Category(name: "low-fat", count: 1)],
             location: GeoPoint(latitude: 4.602703980140069, longitude: -74.06669907728524),
             name: "Mercy Vegan Food",
             price: "$",
             waitTime: WaitTime(min: 10, max: 15),
             reviewData: ReviewData(stats: SpotStats(cleanliness: 4.2727272727272725,
                                                     foodQuality: 3.3636363636363638,
                                                     service: 3.6363636363636362,
                                                     waitTime: 3.0909090909090904),
             userReviews: []), // TODO: add reviews? at least show offline ReviewsView
             imageLinks: ["https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png"]),
        Spot(id: "NJRaBUfiBlNk9v5hsb7D",
             categories: [
                Category(name: "sandwhich", count: 1),
                Category(name: "healthy", count: 1),
                Category(name: "organic", count: 1),
                Category(name: "fast", count: 4),
                Category(name: "burger", count: 2),
                Category(name: "low-fat", count: 1),
                Category(name: "fries", count: 2),
                Category(name: "traditional", count: 1),
                Category(name: "chinese", count: 1)],
             location: GeoPoint(latitude: 4.600965992124167, longitude: -74.06458823178326),
             name: "El Corral",
             price: "$$$",
             waitTime: WaitTime(min: 5, max: 15),
             reviewData: ReviewData(stats: SpotStats(cleanliness: 4,
                                                     foodQuality: 3.8888888888888893,
                                                     service: 4.111111111111112,
                                                     waitTime: 3.7777777777777777),
             userReviews: []), // TODO: add reviews? at least show offline ReviewsView
             imageLinks: ["https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png",
                          "https://static.thenounproject.com/png/944120-200.png"])
        // Add more spots as needed
    ]
}
