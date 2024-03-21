//
//  Utils.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/26/24.
//

import Foundation
import UIKit

final class Utils {
    static let shared = Utils()
    
    private init() {}
    
    
    @MainActor // On the main thread
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        // Warning can be ingored because we are not using multiple scenes (usually reserved for iOS games)
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func isWithinLunchWindow() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let startTime = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!
        let endTime = calendar.date(bySettingHour: 15, minute: 0, second: 0, of: now)!
        return now >= startTime && now <= endTime
    }
    
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
