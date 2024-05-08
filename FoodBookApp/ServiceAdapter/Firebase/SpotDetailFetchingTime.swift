//
//  SpotDetailFetchingTime.swift
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
    
    func createFetchingTime(fetchingTime: FetchingTime) async throws {
        do {
            let documentRef = try collection.addDocument(from: fetchingTime)
        } catch {
            throw error
        }
    }
}
