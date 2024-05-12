//
//  BugReport.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 12/05/24.
//

import Foundation
import FirebaseFirestore


struct BugReport: Codable, Equatable, Hashable  {
    let description: String
    let bugType: String
    let severityLevel: String
    let stepsToReproduce: String
}

