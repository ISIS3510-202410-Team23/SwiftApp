//
//  BackendService.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 20/03/24.
//

import Foundation

final class BackendService: NSObject, ObservableObject {
    struct Answer: Codable {
        let spots: [String]
        let category: String
        let user: String
    }
    
    private let backendUrl = ProcessInfo.processInfo.environment["BACKEND_URL"]
    
    func performAPICall(uid: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let validUrl = backendUrl else {
            print("ERROR: Invalid URL")
            completion(.failure(NSError())) // TODO: Should throw specialized error
            return
        }
        
        let url = URL(string: "\(validUrl)/recommendation/\(uid)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let wrapper = try JSONDecoder().decode(Answer.self, from: data)
                    completion(.success(wrapper.spots))
                } catch {
                    guard let http_response = response as? HTTPURLResponse else {
                        print("ERROR: Response is not an HTTPURLResponse or is nil")
                        return
                    }
                    completion(.failure(NSError(domain: "", code: http_response.statusCode, userInfo: nil)))
                }
            }
        }
        
        task.resume()
    }
    
}
