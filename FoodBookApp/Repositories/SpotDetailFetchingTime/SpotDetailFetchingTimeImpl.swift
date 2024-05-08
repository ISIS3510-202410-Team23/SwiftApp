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
    
    func createFetchingTime(fetchingTime: FetchingTime) async throws {
        return try await SpotDetailFetchingTimeImpl.spotDetailFetchingTimeSA.createFetchingTime(fetchingTime: fetchingTime)
    }
}
