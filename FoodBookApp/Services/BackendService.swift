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

    func performAPICall(uid: String) async throws -> [String ]{
        guard let validUrl = backendUrl else {
            throw NSError() // TODO: Should throw specialized error
        }
        let url = URL(string: "\(validUrl)/recommendation/\(uid)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data)
        let wrapper = try JSONDecoder().decode(Answer.self, from: data)
        print(wrapper)
        return wrapper.spots
    }
}
