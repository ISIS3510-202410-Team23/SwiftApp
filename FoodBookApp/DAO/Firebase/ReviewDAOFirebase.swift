//
//  ReviewDAOFirebase.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import FirebaseFirestore

class ReviewDAOFirebase: ReviewDAO {
    
    static var shared: ReviewDAO = ReviewDAOFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    
    private var collection: CollectionReference
    
    private init () {
        self.collection = client.db.collection("reviews")
    }
   
    func createReview(review: Review) async throws -> String {
            do {
                let documentRef = try collection.addDocument(from: review)
                return documentRef.documentID
            } catch {
                throw error
            }
    }
}
