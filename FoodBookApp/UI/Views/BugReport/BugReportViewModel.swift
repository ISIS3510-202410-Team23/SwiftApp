//
//  BugReportViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 12/05/24.
//

import Foundation

@Observable
class BugReportViewModel {
    static let shared = BugReportViewModel()
    private let repository : BugReportRepository = BugReportRepositoryImpl.shared
    
    func send(description: String, bugType: String, severityLevel: String, stepsToReproduce: String){
        Task {
            do {
                let bugReport = BugReport(description: description, bugType: bugType, severityLevel: severityLevel, stepsToReproduce: stepsToReproduce)
                try await repository.uploadBugReport(bugReport: bugReport)
            } catch {
                print("Error sending bug report: \(error)")
            }
        }
    }
}
