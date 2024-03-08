//
//  SpotsDAOFirebase.swift
//  FoodBookApp
//
//  Created by Maria Castro on 3/4/24.
//

import Foundation
import FirebaseFirestore

class SpotDAOFirebase: SpotDAO {

    static var shared: SpotDAO = SpotDAOFirebase()
    
    private var client: FirebaseClient = FirebaseClient.shared
    
    private var encoder: JSONEncoder
    private var decoder: JSONDecoder 
    
    private var collection: CollectionReference
//    private var reviewDAO = ReviewDAOFirebase() TODO: implement this
    
    private init () {
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.collection = client.db.collection("spots")
    }
    
    func getSpotById(documentId: String) async throws {
        let docRef = collection.document(documentId)

            docRef.getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        print("data", data)
                        guard let reviewInfo = data["review-data"] as? Dictionary<String,Any> else {
                            print("coudl not fetch review info")
                            return
                        }
                        print("ur:", reviewInfo)
                        print("ss", reviewInfo["user-reviews"], type(of: reviewInfo["user-reviews"]))
                        guard let reviewIds = reviewInfo["user-reviews"] as? [DocumentReference] else {
                            print("could not fetch review ids")
                            return
                        }
                        
                        var reviews = [Review]()
                        for ref in reviewIds {
                            let doc = ref.getDocument{(document, error) in
                                if let document = document {
                                    guard let title = document.data()?["title"] else {
                                        return
                                    }
                                    print("t:", title)
                                }
                                
                            }
                            ref.getDocument(as: Review.self) { result in
                                print(result)
                                switch result {
                                case .success(let review):
                                  // A Book value was successfully initialized from the DocumentSnapshot.
                                  print(review)
                                case .failure(let error):
                                  // A Book value could not be initialized from the DocumentSnapshot.
                                  print("Error decoding document: \(error.localizedDescription)")
                                }
                              }
                        
                        }
                        print("ty", reviewIds, type(of: reviewIds))
//                        self.restaurant = data["name"] as? String ?? ""
                    }
                }

            }
        
    }
    
    
}
