//
//  SpotDetailFetchingTimeSA.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 7/05/24.
//

import Foundation

protocol SpotDetailFetchingTimeSA {
    static var shared: SpotDetailFetchingTimeSA { get }
    func createFetchingTime(spotId: String, spotName: String, time: Double) async throws
}
