//
//  UserUtils.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 20/03/24.
//

import Foundation

final class UserUtils {
    func getUsername() async throws -> String {
        do {
            let email = try AuthService.shared.getAuthenticatedUser().email
            if let email = email {
                let usernameComponents = email.split(separator: "@")
                if let username = usernameComponents.first {
                    return String(username)
                } else {
                    throw NSError(domain: "Google", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid email format"])
                }
            } else {
                throw NSError(domain: "Google", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email not found"])
            }
        } catch {
            throw error
        }
    }
}
