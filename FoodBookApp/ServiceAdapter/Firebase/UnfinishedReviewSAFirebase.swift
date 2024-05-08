//
//  UnfinishedReviewSAFirebase.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 16/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class UnfinishedReviewSAFirebase: UnfinishedReviewSA {
    
    static var shared: UnfinishedReviewSA = UnfinishedReviewSAFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    
    private var collection: CollectionReference
    
    lazy var storage = Storage.storage()
        
    private init () {
        self.collection = client.db.collection("unfinishedReviews")
    }
    
    func updateUnfinishedReviewCount(spotId: String, spotName: String) async throws {
        do {
            let documentRef = collection.document(spotId)
            
            let documentSnapshot = try await documentRef.getDocument()
            
            if !documentSnapshot.exists {
                try await documentRef.setData(["spot": spotName, "count": 1])
            } else {
                let count = documentSnapshot.data()?["count"] as? Int ?? 0
                try await documentRef.updateData(["count": count + 1])
            }
        } catch {
            throw error
        }
    }
}
