//
//  BugReportRepositoryImpl.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 12/05/24.
//

import Foundation

class BugReportRepositoryImpl: BugReportRepository {
    static var shared: BugReportRepositoryImpl = BugReportRepositoryImpl()
    static var bugReportSA: BugReportSA = BugReportSAFirebase.shared
    
    func uploadBugReport(bugReport: BugReport) async throws {
        do {
            try await BugReportRepositoryImpl.bugReportSA.uploadBugReport(bugReport: bugReport)
        } catch {
            print(error)
        }
    }
}
