//
//  ExampleRepository.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation

protocol ExampleRepository {
    static var exampleDAO: ExampleDAO { get }
    
    func getSpots() async throws
}
