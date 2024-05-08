//
//  UnfinishedReviewSA.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 16/04/24.
//

import Foundation

protocol UnfinishedReviewSA {
    static var shared: UnfinishedReviewSA { get }
    func updateUnfinishedReviewCount(spotId: String, spotName: String) async throws
}
