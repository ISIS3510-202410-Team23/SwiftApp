//
//  UnfinishedReviewRepository.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 16/04/24.
//

import Foundation
import SwiftUI

protocol UnfinishedReviewRepository {
    static var unfinishedReviewSA: UnfinishedReviewSA { get }
    func updateUnfinishedReviewCount(spot: String) async throws
}
