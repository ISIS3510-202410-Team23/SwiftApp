//
//  Error.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation

enum FirebaseError: Error {
    case documentNotFound(id: String)
    case couldNotBeCreated
    case databaseError
}
