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
    
    func updateUnfinishedReviewCount(user: String) async throws {
        do {
            let querySnapshot = try await collection.whereField("user", isEqualTo: user).getDocuments()
        
            if querySnapshot.documents.isEmpty {
                try await collection.addDocument(data: ["user": user, "count": 1])
            } else {
                let document = querySnapshot.documents[0]
                let count = document.data()["count"] as? Int ?? 0
                try await document.reference.updateData(["count": count + 1])
            }
        } catch {
            throw error
        }
    }
}
