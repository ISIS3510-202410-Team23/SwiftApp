//
//  SpotDetailFetchingTimeRepository.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 7/05/24.
//

import Foundation
import SwiftUI

protocol SpotDetailFetchingTimeRepository {
    static var spotDetailFetchingTimeSA: SpotDetailFetchingTimeSA { get }
    func createFetchingTime(fetchingTime: FetchingTime) async throws
}
