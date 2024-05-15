//
//  BugReportSA.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 12/05/24.
//

import Foundation

protocol BugReportSA {
    static var shared: BugReportSA {get}
    func uploadBugReport(bugReport : BugReport) async throws
}
