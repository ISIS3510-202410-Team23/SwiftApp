//
//  BookmarksUsageSAFirebase.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/20/24.
//

import Foundation
import FirebaseFirestore

class BookmarksUsageSAFirebase: BookmarksUsageSA {
    static var shared: BookmarksUsageSA = BookmarksUsageSAFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    private var collection: CollectionReference
    
        
    private init () {
        self.collection = client.db.collection("bookmarksUsage")
    }
    
    func updateBookmarksUsage(userId: String, usage: Bool) async throws {
        let docRef = collection.document(userId)
        try await docRef.setData(["userId": userId, "usage": usage])
    }
    
    
}
