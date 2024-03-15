//
//  SpotsDAO.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation

protocol SpotDAO {
    static var shared: SpotDAO { get }
    func getSpotById(documentId: String) async throws
}