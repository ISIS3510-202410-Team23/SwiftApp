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
    
    // Repositories Used
    let spotRepo: SpotRepository = SpotRepositoryImpl.shared
    
    // FIXME: only for demostration purposes, should be replaced with real information
    func fetchAllSpots() {
        Task {
            
            do {
                let spots = try await exampleRepo.getSpots()
                print(spots) // FIXME: return spots as [Spots]
                
            } catch {
                // FIXME: Error management
                print("Error fetching spots...")
            }

        }
    }
    
    func fetchSpotById(docId: String) {
        Task {
            do {
                let spot = try await spotRepo.getSpotById(docId: docId)
                print(spot)
            } catch {
                print("Error fetching spot with id \(docId): \(error)")
            }
        }
    }
}
