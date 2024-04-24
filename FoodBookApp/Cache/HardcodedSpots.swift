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
             imageLinks: ["", "", "", "", "", ""])
        // Add more spots as needed
    ]
}
