//
//  CategoryDAOFirebase.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/19/24.
//

import Foundation
import FirebaseFirestore

class CategoryDAOFirebase: CategoryDAO {
    static var shared: CategoryDAO = CategoryDAOFirebase()
    
    private var client = FirebaseClient.shared
    
    private var collection: CollectionReference
    
    private init () {
        self.collection = client.db.collection("categories")
    }
    
    func getCategories() async throws -> [String] {
        let snapshot = try await collection.getDocuments()
        
        let categories: [String] = snapshot.documents.map{ document in
            document["name"] as? String ?? ""
        }
        
        return categories
    }
    
    
}
