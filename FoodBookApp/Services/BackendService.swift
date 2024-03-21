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

    func performAPICall(uid: String) async throws -> [String]{
        let url = URL(string: "https://foodbook-app-backend.2.us-1.fl0.io/recommendation/\(uid)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data)
        let wrapper = try JSONDecoder().decode(Answer.self, from: data)
        print(wrapper)
        return wrapper.spots
    }
}
