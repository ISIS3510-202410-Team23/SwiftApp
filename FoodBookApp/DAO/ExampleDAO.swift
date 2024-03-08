//
//  ExampleDAO.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation

protocol ExampleDAO {
    static var shared: ExampleDAO { get } // Usage of singleton pattern (single instance od ExampleDAO used in the applciation
    
    // Function created as example and to test FB connection. Should go in corresponding DAO.
    // Implementation depends on DB -> ExampleDAOFirebase.swift
    func getSpots() async throws
}
