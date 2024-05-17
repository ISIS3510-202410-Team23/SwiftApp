//
//  DBManager.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 14/04/24.
//

import Foundation
import SQLite
import SwiftUI

class DBManager: ObservableObject {
    
    static let shared = DBManager()
    
    private var db: Connection!
    private var drafts: SQLite.Table!
    private var upload: SQLite.Table!
    private var bug_reports: SQLite.Table!
    private let utils = Utils.shared
    @Published var uploading = false
   
    let notify = NotificationHandler()
    
    // Drafts table columns (reviews)
    private var d_spot: Expression<String>!
    private var d_cat1: Expression<String>!
    private var d_cat2: Expression<String>!
    private var d_cat3: Expression<String>!
    private var d_cleanliness: Expression<Int>!
    private var d_waitTime: Expression<Int>!
    private var d_foodQuality: Expression<Int>!
    private var d_service: Expression<Int>!
    private var d_image: Expression<String>!
    private var d_title: Expression<String>!
    private var d_content: Expression<String>!
    
    // Upload table columns
    private var u_id: Expression<String>!
    private var u_spot: Expression<String>!
    private var u_cat1: Expression<String>!
    private var u_cat2: Expression<String>!
    private var u_cat3: Expression<String>!
    private var u_cleanliness: Expression<Int>!
    private var u_waitTime: Expression<Int>!
    private var u_foodQuality: Expression<Int>!
    private var u_service: Expression<Int>!
    private var u_image: Expression<String>!
    private var u_title: Expression<String>!
    private var u_content: Expression<String>!
    private var u_date: Expression<Date>!
    
    // Bug report drafts table
    private var br_id: Expression<String>!
    private var br_details: Expression<String>!
    private var br_type: Expression<String>!
    private var br_severity: Expression<String>!
    private var br_steps: Expression<String>!
    
    init() {
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            db = try Connection("\(path)/my_local_db.sqlite3")
            drafts = Table("drafts")
            upload = Table("upload")
            bug_reports = Table("bug_reports")
            
            d_spot = Expression<String>("spot")
            d_cat1 = Expression<String>("cat1")
            d_cat2 = Expression<String>("cat2")
            d_cat3 = Expression<String>("cat3")
            d_cleanliness = Expression<Int>("cleanliness")
            d_waitTime = Expression<Int>("waitTime")
            d_foodQuality = Expression<Int>("foodQuality")
            d_service = Expression<Int>("service")
            d_image = Expression<String>("image")
            d_title = Expression<String>("title")
            d_content = Expression<String>("content")
            
            u_id = Expression<String>("id")
            u_spot = Expression<String>("spot")
            u_cat1 = Expression<String>("cat1")
            u_cat2 = Expression<String>("cat2")
            u_cat3 = Expression<String>("cat3")
            u_cleanliness = Expression<Int>("cleanliness")
            u_waitTime = Expression<Int>("waitTime")
            u_foodQuality = Expression<Int>("foodQuality")
            u_service = Expression<Int>("service")
            u_image = Expression<String>("image")
            u_title = Expression<String>("title")
            u_content = Expression<String>("content")
            u_date = Expression<Date>("date")
            
            br_id = Expression<String>("id")
            br_details = Expression<String>("details")
            br_type = Expression<String>("type")
            br_severity = Expression<String>("severity")
            br_steps = Expression<String>("steps")
            
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                //try db.run(drafts.drop(ifExists: true)) -> use when modifying table
                try db.run(drafts.create { (t) in
                    t.column(d_spot, primaryKey: true)
                    t.column(d_cat1)
                    t.column(d_cat2)
                    t.column(d_cat3)
                    t.column(d_cleanliness)
                    t.column(d_waitTime)
                    t.column(d_foodQuality)
                    t.column(d_service)
                    t.column(d_image)
                    t.column(d_title)
                    t.column(d_content)
                })
                try db.run(upload.create { (t) in
                    t.column(u_id, primaryKey: true)
                    t.column(u_spot)
                    t.column(u_cat1)
                    t.column(u_cat2)
                    t.column(u_cat3)
                    t.column(u_cleanliness)
                    t.column(u_waitTime)
                    t.column(u_foodQuality)
                    t.column(u_service)
                    t.column(u_image)
                    t.column(u_title)
                    t.column(u_content)
                    t.column(u_date)
                })
                
                try db.run(bug_reports.create { (t) in
                    t.column(br_id, primaryKey: true)
                    t.column(br_details)
                    t.column(br_type)
                    t.column(br_severity)
                    t.column(br_steps)
                })
                
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {
            print("Error connecting to or creating data base: \(error)")
        }
    }
    
    // MARK: - Add functions
    public func addDraft(spotValue: String, cat1Value: String, cat2Value: String, cat3Value: String,
                         cleanlinessValue: Int, waitTimeValue: Int, foodQualityValue: Int, serviceValue: Int,
                         imageValue: String, titleValue: String, contentValue: String) {
        do {
            try db.run(drafts.insert(d_spot <- spotValue, d_cat1 <- cat1Value, d_cat2 <- cat2Value, d_cat3 <- cat3Value,
                                     d_cleanliness <- cleanlinessValue, d_waitTime <- waitTimeValue, d_foodQuality <- foodQualityValue, d_service <- serviceValue, d_image <- imageValue, d_title <- titleValue, d_content <- contentValue))
            print("Draft added for spot \(spotValue)")
        } catch {
            print("Error adding draft: \(error)")
        }
    }
    
    public func addUpload(idValue: String, spotValue: String, cat1Value: String, cat2Value: String, cat3Value: String,
                          cleanlinessValue: Int, waitTimeValue: Int, foodQualityValue: Int, serviceValue: Int,
                          imageValue: String, titleValue: String, contentValue: String, dateValue: Date) {
        do {
            try db.run(upload.insert(u_id <- idValue, u_spot <- spotValue, u_cat1 <- cat1Value, u_cat2 <- cat2Value,
                                     u_cat3 <- cat3Value, u_cleanliness <- cleanlinessValue, u_waitTime <- waitTimeValue, u_foodQuality <- foodQualityValue, u_service <- serviceValue, u_image <- imageValue, u_title <- titleValue, u_content <- contentValue, u_date <- dateValue))
            print("Upload added for spot \(spotValue)")
        } catch {
            print("Error adding upload: \(error)")
        }
    }
    
    public func addBugReportDraft(detailsValue: String, typeValue: String, severityValue: String, stepsValue: String) {
        do {
            // Hard coded id bc we only allow one bug report draft
            try db.run(bug_reports.insert(br_id <- "bug_report", br_details <- detailsValue, br_type <- typeValue,
                                          br_severity <- severityValue, br_steps <- stepsValue))
            print("Bug report draft added")
        } catch {
            print("Error adding bug report draft: \(error)")
        }
    }
    
    // MARK: - Get functions
    func getDraft(spot: String) -> ReviewDraft? {
        do {
            if let row = try db.pluck(drafts.filter(self.d_spot == spot)) {
                let cleanliness = try row.get(self.d_cleanliness)
                let foodQuality = try row.get(self.d_foodQuality)
                let service = try row.get(self.d_service)
                let waitTime = try row.get(self.d_waitTime)
                let selectedCategories = [try row.get(self.d_cat1), try row.get(self.d_cat2), try row.get(self.d_cat3)]
                let reviewStats = ReviewDraftStats(cleanliness: cleanliness, foodQuality: foodQuality, service: service, waitTime: waitTime)
                let image = try row.get(self.d_image)
                let title = try row.get(self.d_title)
                let content = try row.get(self.d_content)
                
                print("Draft retrieved")
                
                return ReviewDraft(selectedCategories: selectedCategories, ratings: reviewStats, image: image, title: title, content: content)
            }
        } catch {
            print("Error retrieving draft: \(error)")
        }
        return nil
    }
    
    func getBugreportDraft() -> BugReportDraft? {
        do {
            if let row = try db.pluck(bug_reports.filter(self.br_id == "bug_report")) {
                let details = try row.get(self.br_details)
                let type = try row.get(self.br_type)
                let severity = try row.get(self.br_severity)
                let steps = try row.get(self.br_steps)
                
                print("Bug report draft retrieved")
                
                return BugReportDraft(details: details, type: type, severity: severity, steps: steps)
            }
        } catch {
            print("Error retrieving bug report draft: \(error)")
        }
        return nil
    }
    
    // MARK: - Exist functions
    public func draftExists(spot: String) -> Bool {
        do {
            if (try db.pluck(drafts.filter(self.d_spot == spot))) != nil {
                return true
            }
            else {
                return false
            }
        } catch {
            print("Error finding if draft exists: \(error)")
        }
        return false
    }
    
    public func bugReportDraftExists() -> Bool {
        do {
            if (try db.pluck(bug_reports.filter(self.br_id == "bug_report"))) != nil {
                return true
            }
            else {
                return false
            }
        } catch {
            print("Error finding if bug report draft exists: \(error)")
        }
        return false
    }
    
    // MARK: - Delete functions
    func deleteDraft(spot: String) {
        let draftToDelete = drafts.filter(self.d_spot == spot)
        do {
            try db.run(draftToDelete.delete())
            print("Draft deleted for spot \(spot)")
        } catch {
            print("Error deleting draft: \(error)")
        }
    }
    
    func deleteUpload(id: String) {
        let uploadToDelete = upload.filter(self.u_id == id)
        do {
            try db.run(uploadToDelete.delete())
            print("Upload with \(id) id deleted")
        } catch {
            print("Error deleting upload: \(error)")
        }
    }
    
    func deleteBugReportDraft() {
        let bugReportToDelete = bug_reports.filter(self.br_id == "bug_report")
        do {
            try db.run(bugReportToDelete.delete())
            print("Bug report draft deleted")
        } catch {
            print("Error deleting bug report draft: \(error)")
        }
    }
    
    func deleteDraftImage(spot: String) {
        do {
            if let row = try db.pluck(drafts.filter(self.d_spot == spot)) {
                let image = try row.get(self.d_image)
                if (image != "") {
                    let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(image)
                    try FileManager.default.removeItem(atPath: imagePath.path)
                }
            }
        } catch {
            print("Error deleting image of spot: \(error)")
        }
    }
    
    func deleteUploadImage(id: String) {
        do {
            if let row = try db.pluck(upload.filter(self.u_id == id)) {
                let image = try row.get(self.d_image)
                if (image != "") {
                    let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(image)
                    try FileManager.default.removeItem(atPath: imagePath.path)
                }
            }
        } catch {
            print("Error deleting image of upload: \(error)")
        }
    }
    
    func deleteAllImages() {
        do {
            let drafts_rows = try db.prepare(drafts)
            for row in drafts_rows {
                let image = try row.get(self.d_image)
                if (image != "") {
                    let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(image)
                    try FileManager.default.removeItem(atPath: imagePath.path)
                }
            }
            let upload_rows = try db.prepare(upload)
            for row in upload_rows {
                let image = try row.get(self.u_image)
                if (image != "") {
                    let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(image)
                    try FileManager.default.removeItem(atPath: imagePath.path)
                }
            }
        } catch {
            print("Error deleting images: \(error)")
        }
    }
    
    
    func deleteTables() {
        do {
            try db.run(drafts.drop(ifExists: true))
            try db.run(upload.drop(ifExists: true))
            try db.run(bug_reports.drop(ifExists: true))
            UserDefaults.standard.set(false, forKey: "is_db_created")
        }
        catch {
            print("Error deleting drafts table: \(error)")
        }
    }
    
    // MARK: - Other functions
    @MainActor
    func uploadReviews() async throws {
        self.uploading = true
        do {
            let rows = try db.prepare(upload)
            let count = try db.scalar(upload.count)
            
            if count > 0 {
                for row in rows {
                    let id = try row.get(self.u_id)
                    let image = try row.get(self.u_image)
                    var selectedImage: UIImage?
                    if (image != "") {
                        let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(image)
                        selectedImage = UIImage(contentsOfFile: imagePath.path)
                    }
                    else {
                        selectedImage = nil
                    }
                    let reviewImage = try await utils.uploadPhoto(image: selectedImage)
                    let content = try row.get(self.u_content)
                    let date = try row.get(self.u_date)
                    let cleanliness = try row.get(self.u_cleanliness)
                    let foodQuality = try row.get(self.u_foodQuality)
                    let service = try row.get(self.u_service)
                    let waitingTime = try row.get(self.u_waitTime)
                    var categories = [try row.get(self.u_cat1), try row.get(self.u_cat2), try row.get(self.u_cat3)]
                    categories = categories.filter { !$0.isEmpty }
                    let title = try row.get(self.u_title)
                    let username = try await utils.getUsername()
                    let user = try await utils.getUser()
                    let newReview = Review(content: content == "" ? nil : content,
                                           date: date,
                                           imageUrl: reviewImage,
                                           ratings: ReviewStats(
                                            cleanliness: cleanliness,
                                            foodQuality: foodQuality,
                                            service: service,
                                            waitTime: waitingTime),
                                           selectedCategories: categories,
                                           title: title == "" ? nil : title,
                                           user: UserInfo(id: username, name: user))
                    let reviewId = try await utils.addReview(review: newReview)
                    let spot = try row.get(self.u_spot)
                    try await utils.addReviewToSpot(spotId: spot, reviewId: reviewId)
                    deleteUploadImage(id: id)
                    deleteUpload(id: id)
                }
                notify.sendUploadedReviewsNotification()
            }
        } catch {
            print("Error uploading reviews: \(error)")
        }
        self.uploading = false
    }
}
