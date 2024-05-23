//
//  ReviewSAFirebase.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ReviewSAFirebase: ReviewSA {
    
    static var shared: ReviewSA = ReviewSAFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    
    private var collection: CollectionReference
    
    private let utils = Utils.shared
    
    lazy var storage = Storage.storage()
        
    private init () {
        self.collection = client.db.collection("reviews")
    }
   
    func createReview(review: Review) async throws -> String {
            do {
                let documentRef = try collection.addDocument(from: review)
                return documentRef.documentID
            } catch {
                throw error
            }
    }
    
    func uploadPhoto(image: UIImage) async throws -> String {
        
        let storageRef = storage.reference()
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image data"])
        }
        
        let uuid = UUID().uuidString
        let imageRef = storageRef.child("\(uuid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData, metadata: metadata)

        // FIXME: dont reveal url (?)
        let url = "https://firebasestorage.googleapis.com/v0/b/foodbook-back.appspot.com/o/\(uuid).jpg?alt=media"
        return url
    }
    
    func uploadReviewReport(reviewId: String, reason: String) async throws {
        let reportsCollection = client.db.collection("reviewReports")
        let reviewRef = collection.document(reviewId)
        let user = try? AuthService.shared.getAuthenticatedUser()
        try await reportsCollection.addDocument(data: ["reviewId": reviewRef, "reason": reason, "date": Date(), "reportedBy": user?.email ?? ""])
    }
    
    func getUserReviews(name: String, username: String) async throws -> [Review] {
        let query = collection.whereField("user", isEqualTo: ["id": username, "name": name])
        
        do {
            let snapshot = try await query.getDocuments()
            var userReviews: [Review] = []

            for document in snapshot.documents {
                print("FIREBASE: Trying to fetch document \(document.documentID)")
                let review = try document.data(as: Review.self)
                userReviews.append(review)
            }
            
            return userReviews
        } catch {
            // Handle error
            throw error
        } 
    }


 }
