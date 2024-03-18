//
//  NotificationHandler.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 17/03/24.
//

import Foundation
import UserNotifications

class NotificationHandler {
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        { success, error in
            if success {
                print("Access granted!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func sendLastReviewNotification(date: Date) {
        
        let notificationIdentifier = "lastReviewNotification"

        cancelNotification(identifier: notificationIdentifier)
                    
        let triggerDate = Calendar.current.date(byAdding: .second, value: 5, to: date)!
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate), repeats: false)
                
        let content = UNMutableNotificationContent()
        content.title = "We miss you..."
        content.body = "You haven't left a review in the past 4 days"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
