//
//  UserViewModel.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 7/05/24.
//

import Foundation

@Observable
class UserViewModel {
    static let shared = UserViewModel()
    
    private init() {}
    
    private let searchRepository: SearchUsageRepository = SearchUsageRepositoryImpl.shared
    
    private let fileURL: URL = {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsDirectory.appendingPathComponent("inputHistory.json")
        }()
    
    func saveSearchItems() async {
        let items = loadInputHistory()
        if !items.isEmpty {
            do {
                try await searchRepository.updateSharedItems(items: items)
            } catch {
                print("Error saving search items \(error)")
            }
        }
    }
    
    func deleteFileContents() {
        do {
            print("deleting contents \(fileURL)")
            let emptyString = ""
            try emptyString.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print("Could not remove contents of the file: \(error)")
        }
    }
    
    func loadInputHistory() -> [String] {
        if let data = try? Data(contentsOf: fileURL),
           let history = try? JSONDecoder().decode([String].self, from: data) {
            return history
        }
        return []
    }
    
}
