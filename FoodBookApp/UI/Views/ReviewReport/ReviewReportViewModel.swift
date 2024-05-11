//
//  ReviewReportViewModel.swift
//  FoodBookApp
//
//  Created by Maria Castro on 5/11/24.
//

import Foundation

enum ReportReason: String, CaseIterable {
    static var allCases: [ReportReason] {
        return [ .offensiveContent, .offensiveImage, .falseInfo, .spam]
    }
    case offensiveContent = "Contains offensive content"
    case offensiveImage = "Contains offensive image"
    case falseInfo = "Contains false information"
    case spam = "It's spam"
}

@Observable
class ReviewReportViewModel {
    
    static let shared = ReviewReportViewModel()
    
    func sendReport(reviewId: String, reason: ReportReason) {
        Task {
            try await Task.sleep(for: .seconds(10))
            print("Sent report for \(reason) to review \(reviewId)")
            
        }
    }
    
}
