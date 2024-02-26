//
//  BackendService.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation

class BackendService {
    
    // FIXME: only for demostration purposeas
    let exampleRepo: ExampleRepository = ExampleRepositoryImpl.shared
    
    // FIXME: only for demostration purposes, should be replaced with real information
    func fetchAllSpots() {
        Task {
            
            do {
                let spots = try await exampleRepo.getSpots()
                print(spots)
                
            } catch {
                // FIXME: Error management
                print("Error fetching spots...")
            }

        }
    }
}
