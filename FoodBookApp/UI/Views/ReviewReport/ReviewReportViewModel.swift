//
//  ReviewReportViewModel.swift
//  FoodBookApp
//
//  Created by Maria Castro on 5/11/24.
//

import Foundation

enum ReportReason: String, CaseIterable {
    static var allCases: [ReportReason] {
        return [ .offensiveContent, .offensiveImage, .falseInfo, .spam, .other]
    }
    case offensiveContent = "Contains offensive content"
    case offensiveImage = "Contains offensive image"
    case falseInfo = "Contains false information"
    case spam = "It's spam"
    case other = "Other"
}

@Observable
class ReviewReportViewModel {
    
    static let shared = ReviewReportViewModel()
    private let repository: ReviewRepository = ReviewRepositoryImpl.shared
    
    func sendReport(reviewId: String, reason: String) {
        Task {
            do {
                try await repository.uploadReviewReport(reviewId: reviewId, reason: reason)
            } catch {
                print("There was an error uploading the report: \(error)")
            }
            
        }
    }
    
}
