//
//  BugReportSAFirebase.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 12/05/24.
//

import Foundation
import FirebaseFirestore

class BugReportSAFirebase: BugReportSA {
    static var shared: BugReportSA = BugReportSAFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    private var collection: CollectionReference
    
    private init () {
        self.collection = client.db.collection("bugReports")
    }
    
    
    func uploadBugReport(bugReport : BugReport) async throws {
        do {
            let documentRef = try collection.addDocument(from: bugReport)
        } catch {
            throw error
        }
    }
    
    
}
