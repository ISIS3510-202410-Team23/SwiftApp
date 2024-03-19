//
//  SpotsDAOFirebase.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation
import FirebaseFirestore

class SpotDAOFirebase: SpotDAO {
    
    static var shared: SpotDAO = SpotDAOFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    
    private var collection: CollectionReference
    
    private init () {
        self.collection = client.db.collection("spots")
    }
    
    func getSpotById(documentId: String) async throws -> Spot {
       let snapshot = try await collection.document(documentId).getDocument()

        let spot = try snapshot.data(as: SpotDTO.self)

        var reviews = [Review]()

        for reviewRef in spot.reviewData.userReviews {
            let review = try await self.getReview(ref: reviewRef)
            reviews.append(review)
        }
           
        print("Completed spot fetch \(documentId)")
        return Spot(categories: spot.categories, location: spot.location, name: spot.name, price: spot.price, waitTime: spot.waitTime, reviewData: ReviewData(stats: spot.reviewData.stats, userReviews: reviews), imageLinks: spot.imageLinks)
    }
    
    func getReview(ref: DocumentReference) async throws -> Review {
        let snapshot = try await ref.getDocument()
        return try snapshot.data(as: Review.self)
    }
    
    func updateSpot(documentId: String, reviewId: String) async throws {
        let spotRef = collection.document(documentId)
        let reviewRef = client.db.collection("reviews").document(reviewId)
        try await spotRef.updateData(["reviewData.userReviews": FieldValue.arrayUnion([reviewRef])])
    }
    
}
