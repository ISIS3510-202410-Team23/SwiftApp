//
//  FetchingTime.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 7/05/24.
//

import Foundation
import FirebaseFirestore

struct FetchingTime: Codable, Equatable, Hashable, Identifiable {
    @DocumentID var id: String?
    let spot: String!
    let time: Float
}
