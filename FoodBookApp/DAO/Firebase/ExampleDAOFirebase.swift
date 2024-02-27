//
//  ExampleDAOFirebase.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation

class ExampleDAOFirebase: ExampleDAO {
    static var shared: ExampleDAO = ExampleDAOFirebase()
    
    private var client: FirebaseClient = FirebaseClient()
    
    func getSpots() async throws {
        do {
            let snapshot = try await client.db.collection("spots").getDocuments()
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
              }
        }
        
    }
    
    
}
