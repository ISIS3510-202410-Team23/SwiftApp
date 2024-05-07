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
    private let reviewRepository: ReviewRepository = ReviewRepositoryImpl.shared
    private let spotRepository: SpotRepository = SpotRepositoryImpl.shared
    
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
    
    //User ID
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
    
    //User name
    func getUser() async throws -> String? {
        do {
            let name = try AuthService.shared.getAuthenticatedUser().name
            if let name = name {
                return String(name)
            } else {
                throw NSError(domain: "Google", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
            }
        } catch {
            throw error
        }
    }
    
    func highestCategories(spot: Spot) -> [Category] {
        var sortedCategories = [Category]()
        let queue = DispatchQueue(label: "sortingQueue", attributes: .concurrent)

        DispatchQueue.concurrentPerform(iterations: spot.categories.count) { index in
            let category = spot.categories[index]
            queue.async(flags: .barrier) {
                sortedCategories.append(category)
            }
        }

        queue.sync(flags: .barrier) {}

        sortedCategories.sort { $0.count > $1.count }

        return sortedCategories
    }

    func saveLocalImage(image: UIImage?, imageName: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
        do {
            try image?.jpegData(compressionQuality: 1)?.write(to: path)
            print("Image saved locally")
        }
        catch {
            print("Error saving image: \(error.localizedDescription)")
        }
    }
    
    func uploadPhoto(image: UIImage?) async throws -> String? {
        guard let image = image else {
                return nil
            }
        do {
            let url = try await reviewRepository.uploadPhoto(image: image)
            return url
        } catch {
            throw error
        }
    }
    
    func addReview(review: Review) async throws -> String {
        do {
            let id = try await reviewRepository.createReview(review: review)
            return id
        } catch {
            throw error
        }
    }
    
    func addReviewToSpot(spotId: String, reviewId: String) async throws {
        do {
            try await spotRepository.updateSpot(docId: spotId, revId: reviewId)
        } catch {
            throw error
        }
    }
}
