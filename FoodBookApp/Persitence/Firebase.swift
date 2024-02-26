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
    // TODO: add variable for auth service
    
    init() {
        self.db = Firestore.firestore()
    }
    
}
