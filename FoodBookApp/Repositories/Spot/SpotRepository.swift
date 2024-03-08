//
//  SpotRepository.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation

protocol SpotRepository {
    static var spotDao: SpotDAO { get }
    
//    func getSpots() async throws
    
    func getSpotById(docId: String) async throws
}
