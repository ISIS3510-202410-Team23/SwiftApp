//
//  DBManager.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 14/04/24.
//

import Foundation
import SQLite

class DBManager {
    private var db: Connection!
    private var drafts: Table!
    
    private var spot: Expression<String>!
    private var cat1: Expression<String>!
    private var cat2: Expression<String>!
    private var cat3: Expression<String>!
    private var cleanliness: Expression<Int>!
    private var waitTime: Expression<Int>!
    private var foodQuality: Expression<Int>!
    private var service: Expression<Int>!
    //private var image: Expression<String?>!
    private var title: Expression<String>!
    private var content: Expression<String>!
    private var upload: Expression<Bool>!
    
    init() {
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            db = try Connection("\(path)/my_drafts.sqlite3")
            drafts = Table("drafts")
            
            spot = Expression<String>("spot")
            cat1 = Expression<String>("cat1")
            cat2 = Expression<String>("cat2")
            cat3 = Expression<String>("cat3")
            cleanliness = Expression<Int>("cleanliness")
            waitTime = Expression<Int>("waitTime")
            foodQuality = Expression<Int>("foodQuality")
            service = Expression<Int>("service")
            //image = Expreession<String?>("image")
            title = Expression<String>("title")
            content = Expression<String>("content")
            upload = Expression<Bool>("upload")
            
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                //try db.run(drafts.drop(ifExists: true)) -> use when moifying table
                try db.run(drafts.create { (t) in
                    t.column(spot, primaryKey: true)
                    t.column(cat1)
                    t.column(cat2)
                    t.column(cat3)
                    t.column(cleanliness)
                    t.column(waitTime)
                    t.column(foodQuality)
                    t.column(service)
                    //t.column(image)
                    t.column(title)
                    t.column(content)
                    t.column(upload)
                })
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    //(C)RUD
    public func addDraft(spotValue: String, cat1Value: String, cat2Value: String, cat3Value: String,
                         cleanlinessValue: Int, waitTimeValue: Int, foodQualityValue: Int, serviceValue: Int,
                         titleValue: String, contentValue: String, uploadValue: Bool) {
        do {
            try db.run(drafts.insert(spot <- spotValue, cat1 <- cat1Value, cat2 <- cat2Value, cat3 <- cat3Value,
                                     cleanliness <- cleanlinessValue, waitTime <- waitTimeValue, foodQuality <- foodQualityValue,
                                     service <- serviceValue, title <- titleValue, content <- contentValue, upload <- uploadValue))
            print("Draft added for spot \(spotValue)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func draftExists(spot: String) -> Bool {
        do {
            if (try db.pluck(drafts.filter(self.spot == spot))) != nil {
                return true
            }
            else {
                return false
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    //C(R)UD
    func getDraft(spot: String) -> ReviewDraft? {
        do {
            if let row = try db.pluck(drafts.filter(self.spot == spot)) {
                let content = try row.get(self.content)
                let cleanliness = try row.get(self.cleanliness)
                let foodQuality = try row.get(self.foodQuality)
                let service = try row.get(self.service)
                let waitTime = try row.get(self.waitTime)
                let selectedCategories = [try row.get(self.cat1), try row.get(self.cat2), try row.get(self.cat3)]
                let title = try row.get(self.title)
                let reviewStats = ReviewDraftStats(cleanliness: cleanliness, foodQuality: foodQuality, service: service, waitTime: waitTime)
                let upload = try row.get(self.upload)
                
                print("Draft retrieved")
                
                return ReviewDraft(content: content, ratings: reviewStats, selectedCategories: selectedCategories, title: title, upload: upload)
            }
        } catch {
            print("Error retrieving draft: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    //CRU(D)
    func deleteDraft(spot: String) {
        let draftToDelete = drafts.filter(self.spot == spot)
        do {
            try db.run(draftToDelete.delete())
            print("Draft deleted for spot \(spot)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
