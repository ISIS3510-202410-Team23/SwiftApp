//
//  BugReportRepository.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 12/05/24.
//

import Foundation

protocol BugReportRepository {
    static var bugReportSA: BugReportSA {get}
    func uploadBugReport(bugReport:BugReport) async throws
}
