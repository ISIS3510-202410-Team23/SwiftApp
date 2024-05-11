//
//  SpotDetailFetchingTimeImpl.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 7/05/24.
//

import Foundation
import SwiftUI

class SpotDetailFetchingTimeImpl: SpotDetailFetchingTimeRepository {
    static var shared: SpotDetailFetchingTimeRepository = SpotDetailFetchingTimeImpl()
    static var spotDetailFetchingTimeSA: SpotDetailFetchingTimeSA = SpotDetailFetchingTimeSAFirebase.shared
    
    func createFetchingTime(spotId: String, spotName: String, time: Double) async throws {
        return try await SpotDetailFetchingTimeImpl.spotDetailFetchingTimeSA.createFetchingTime(spotId: spotId, spotName: spotName, time: time)
    }
}
