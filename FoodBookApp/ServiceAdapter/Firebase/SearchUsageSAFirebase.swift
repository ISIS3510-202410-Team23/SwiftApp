//
//  SearchUsageSAFirebase.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 7/05/24.
//

import Foundation
import FirebaseFirestore

class SearchUsageSAFirebase: SearchUsageSA {
    static var shared: SearchUsageSA = SearchUsageSAFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    private var collection: CollectionReference
    
    private init () {
        self.collection = client.db.collection("searchTerms")
    }
    
    
    func updateSharedItems(items: [String]) async throws {
        let data: [String: Any] = [
            "terms": items
        ]
        
        try await collection.addDocument(data: data)
    }
    
}
