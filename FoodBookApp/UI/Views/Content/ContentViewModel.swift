//
//  ContentViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 16/04/24.
//

import Foundation
import CoreData
import FirebaseFirestore

@Observable
class ContentViewModel {
    var browseSpots: [Spot] = []
    var forYouSpots: [Spot] = []
    
    private let locationService = LocationService.shared
    private let locationUtils = LocationUtils()
    private let repository: SpotRepository = SpotRepositoryImpl.shared
//    private let backendService = BackendService()
    private let utils = Utils.shared
    
//    private let cache = NSCache<NSString, Spot>()
    
    func fetch() async throws {
        
    }
}
