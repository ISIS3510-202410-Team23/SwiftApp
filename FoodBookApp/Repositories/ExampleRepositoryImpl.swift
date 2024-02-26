//
//  ExampleRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation


class ExampleRepositoryImpl: ExampleRepository {
    
    static var shared: ExampleRepository = ExampleRepositoryImpl()
    static var exampleDAO: ExampleDAO = ExampleDAOFirebase.shared // FIXME: is there a way to abstract this more?
    
    func getSpots() async throws {
         return try await ExampleRepositoryImpl.exampleDAO.getSpots() 
    }
}
