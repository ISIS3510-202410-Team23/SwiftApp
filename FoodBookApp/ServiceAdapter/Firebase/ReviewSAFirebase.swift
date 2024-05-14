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
    
    func getUserReviews() async throws -> [Review] {
        // TODO: actual function
        //let userId = try await utils.getUsername()
        return [
            Review(
                content: "Lo digo y lo insisto, mi caserito es el restaurante más completo de los andes.",
                date: Date(),
                imageUrl: "https://i.ytimg.com/vi/1n6bq4wfoSU/hq720.jpg?sqp=-oaymwEXCK4FEIIDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLCCW-rqYpxNt3xW3Ag43ns--EwGLw",
                ratings: ReviewStats(cleanliness: 5, foodQuality: 5, service: 5, waitTime: 4),
                selectedCategories: ["Homemade", "Dessert"],
                title: "Me fascina!!",
                user: UserInfo(id: try await utils.getUsername(), name: "Juan Pedro Gonzalez")
            ),
            Review(
                content: "La comida me gustó pero la atención fue pésima, se demoró muchísimo, lástima.",
                date: Date(),
                imageUrl: nil,
                ratings: ReviewStats(cleanliness: 2,
                                     foodQuality: 3,
                                     service: 1,
                                     waitTime: 1),
                
                selectedCategories: ["Poultry", "Rice", "Soup"],
                title: "No lo recomiendo.",
                user: UserInfo(id: try await utils.getUsername(), name:"Mariana Martínez")
            )
        ]
    }

 }
