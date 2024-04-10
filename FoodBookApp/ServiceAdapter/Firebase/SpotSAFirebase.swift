//
//  SpotsSAFirebase.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation
import FirebaseFirestore

class SpotSAFirebase: SpotSA {
    static var shared: SpotSA = SpotSAFirebase()
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
           
        print("FIREBASE: Completed spot fetch \(documentId)")
        return Spot(categories: spot.categories, location: spot.location, name: spot.name, price: spot.price, waitTime: spot.waitTime, reviewData: ReviewData(stats: spot.reviewData.stats, userReviews: reviews), imageLinks: spot.imageLinks)
    }
    
    func getReview(ref: DocumentReference) async throws -> Review {
        let snapshot = try await ref.getDocument()
        return try snapshot.data(as: Review.self)
    }
    

    func getSpots() async throws -> [Spot] {
        let snapshot = try await collection.getDocuments()
        var spots = [Spot]()

        for document in snapshot.documents {
            print("FIREBASE: Trying to fetch document \(document.documentID)")
            let spotDTO = try document.data(as: SpotDTO.self)

            let spot = Spot(
                id: spotDTO.id,
                categories: spotDTO.categories,
                location: spotDTO.location,
                name: spotDTO.name,
                price: spotDTO.price,
                waitTime: spotDTO.waitTime,
                reviewData: ReviewData(
                    stats: spotDTO.reviewData.stats,
                    userReviews: []
                ),
                imageLinks: spotDTO.imageLinks
            )
            spots.append(spot)
        }
        return spots
    }
  
    func updateSpot(documentId: String, reviewId: String) async throws {
        let spotRef = collection.document(documentId)
        let reviewRef = client.db.collection("reviews").document(reviewId)
        try await spotRef.updateData(["reviewData.userReviews": FieldValue.arrayUnion([reviewRef])])
    }
    
    func getSpotsWithIDList(docIDs: [String]) async throws -> [Spot] {
        var spots: [Spot] = []
        for doc in docIDs {
            let snapshot = try await collection.document(doc).getDocument()
            let spot = try snapshot.data(as: SpotDTO.self)
            print("FIREBASE: Completed spot fetch \(doc)")
            spots.append(
                Spot(
                    id: spot.id,
                    categories: spot.categories,
                    location: spot.location,
                    name: spot.name,
                    price: spot.price,
                    waitTime: spot.waitTime,
                    reviewData: ReviewData(
                        stats: spot.reviewData.stats,
                        userReviews: []),
                    imageLinks: spot.imageLinks)
            )
        }
        return spots
    }
}
