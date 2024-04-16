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
    
    func increaseUnfinishedReviewCount(user: String) async throws {
            do {
                let document = collection.document(user)
                let documentSnapshot = try await document.getDocument()
                
                if !documentSnapshot.exists {
                    try await document.setData(["count": 1])
                } else {
                    try await document.updateData(["count": FieldValue.increment(Int64(1))])
                }
            } catch {
                throw error
            }
        }
}
