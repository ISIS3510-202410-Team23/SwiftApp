//
//  BackendService.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 20/03/24.
//

import Foundation

struct Answer: Codable {
    let spots: [String]
    let category: String
    let user: String
}

struct HotCategories: Codable {
    let categories: [Category]
}

class BackendService {
    static let shared = BackendService()
    //    private let backendUrl = ProcessInfo.processInfo.environment["BACKEND_URL"] TODO: Find a workaround
    private let backendUrl = "https://foodbook-app-backend.vercel.app"
    private init () {}
}

extension BackendService {
    
    // MARK: - For You
    func performAPICall(uid: String) async throws -> [String] {
        //        guard let validUrl = backendUrl else {
        //            print("ERROR: Invalid URL")
        //            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        //        }
        
        let validUrl = backendUrl
        
        guard let url = URL(string: "\(validUrl)/recommendation/\(uid)") else {
            print("ERROR: Invalid URL")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let http_response = response as? HTTPURLResponse, !(200...299).contains(http_response.statusCode) {
                print("HTTP status code \(http_response.statusCode)")
                if http_response.statusCode == 404 {
                    return ["404"]
                }
                throw NSError(domain: "", code: http_response.statusCode, userInfo: nil)
            }
            
            let wrapper = try JSONDecoder().decode(Answer.self, from: data)
            return wrapper.spots
            
        } catch {
            if let urlError = error as? URLError, urlError.code == .cancelled {
                print("API call was cancelled")
            } else {
                print("Error performing API call: \(error)")
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error performing API call"])
            }
            return []
        }
    }
    
    // MARK: - Hottest Categories
    func fetchHottestCategories() async throws -> [Category] {
        let validUrl = backendUrl
        
        guard let url = URL(string: "\(validUrl)/hottest_categories") else {
            print("ERROR: Invalid URL")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let http_response = response as? HTTPURLResponse, !(200...299).contains(http_response.statusCode) {
                print("HTTP status code \(http_response.statusCode)")
                if http_response.statusCode == 404 {
//                    return ["404"]
                    // TODO: not sure what to do here
                    return []
                }
                throw NSError(domain: "", code: http_response.statusCode, userInfo: nil)
            }
            
            let wrapper = try JSONDecoder().decode(HotCategories.self, from: data)
            return wrapper.categories
            
        } catch {
            if let urlError = error as? URLError, urlError.code == .cancelled {
                print("API call was cancelled")
            } else {
                print("Error performing API call: \(error)")
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error performing API call"])
            }
            return []
        }
    }
}
