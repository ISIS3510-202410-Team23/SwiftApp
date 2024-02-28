//
//  ReviewsViewModel.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import Observation

@Observable
class ReviewsViewModel {
    var reviews: [Review] = []
    
    func fetchReviews() async throws -> [Review] { // FIXME: should receive spot's ID
        // TODO: actual fetch
        try await Task.sleep(nanoseconds: 20000)
        
        reviews = [Review(cleanliness: 5,
                          waitingTime: 4,
                          service: 5,
                          foodQuality: 5,
                          tags: ["Homemade", "Dessert"],
                          description: "Lo digo y lo insisto, mi caserito es el restaurante más completo de los andes.",
                          title: "Me fascina!!",
                          photo: "homemade-lunch",
                          user: "Juan Pedro Gonzalez",
                          date: Date()),
                   Review(cleanliness: 2,
                           waitingTime: 1,
                           service: 1,
                           foodQuality: 3,
                           tags: ["Poultry", "Rice", "Soup"],
                           description: "La comida me gustó pero la atención fue pésima, se demoró muchísimo, lástima.",
                           title: "No lo recomiendo.",
                           photo: "",
                           user: "Mariana Martínez",
                           date: Date())]
        return reviews
    }
}

