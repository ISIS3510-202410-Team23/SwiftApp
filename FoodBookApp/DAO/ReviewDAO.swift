//
//  ReviewDAO.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import SwiftUI

protocol ReviewDAO {
    static var shared: ReviewDAO { get }
    func createReview(review: Review) async throws -> String
    func uploadPhoto(image: UIImage) async throws -> String
}
