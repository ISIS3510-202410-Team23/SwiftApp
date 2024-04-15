//
//  Firebase.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation

import FirebaseCore
import FirebaseFirestore


class FirebaseClient {
    var db: Firestore
    
    static var shared = FirebaseClient()
    
    private init() {
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        self.db = Firestore.firestore()
        self.db.settings = settings
        
    }
    
}
