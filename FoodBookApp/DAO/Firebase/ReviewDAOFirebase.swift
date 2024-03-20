//
//  ReviewDAOFirebase.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 18/03/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ReviewDAOFirebase: ReviewDAO {
    
    static var shared: ReviewDAO = ReviewDAOFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    
    private var collection: CollectionReference
    
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

 }
