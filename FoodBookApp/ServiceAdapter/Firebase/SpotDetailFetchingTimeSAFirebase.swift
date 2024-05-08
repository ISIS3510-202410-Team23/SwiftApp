//
//  SpotDetailFetchingTimeSAFirebase.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 7/05/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class SpotDetailFetchingTimeSAFirebase: SpotDetailFetchingTimeSA {
    
    static var shared: SpotDetailFetchingTimeSA = SpotDetailFetchingTimeSAFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    
    private var collection: CollectionReference
    
    lazy var storage = Storage.storage()
    
    private init () {
        self.collection = client.db.collection("spotDetailFetchingTime")
    }
    
    func createFetchingTime(spotId: String, spotName: String, time: Double) async throws {
        do {
            let docRef = collection.document(spotId)
            let documentSnapshot = try await docRef.getDocument()

            if !documentSnapshot.exists {
                try await docRef.setData(["spot": spotName, "times": [time]])
            } else {
                try await docRef.updateData(["times": FieldValue.arrayUnion([time])])
            }
        } catch {
            throw error
        }
    }
}
