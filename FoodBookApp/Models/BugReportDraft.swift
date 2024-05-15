//
//  BugReportDraft.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 13/05/24.
//

import Foundation

struct BugReportDraft: Codable, Equatable, Hashable {
    let details: String
    let type: String
    let severity: String
    let steps: String
}
