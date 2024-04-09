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
                    
        let triggerDate = Calendar.current.date(byAdding: .day, value: 4, to: date)!
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate), repeats: false)
                
        let content = UNMutableNotificationContent()
        content.title = "We miss you..."
        content.body = "You haven't left a review in a while"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendLunchTimeReminder(identifier: String) {
        
        if hasDayPassedSinceLastNotification() {
            print("Sending daily notification...")
            let notificationIdentifier = "lunchTimeNotification"
            
            // i18n
            let title = "Hungry? It's lunchtime!"
            let body = "Looks like you're on campus, find a spot or rate the one you've been at!"
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(5), repeats: false) // Send notif almost immedtiately
            
            let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
            
            saveLastNotificationTime(Date())
            UNUserNotificationCenter.current().add(request)
        } else {
            print("Notif already sent")
        }
        
    }
    
    private func saveLastNotificationTime(_ time: Date) {
        UserDefaults.standard.set(time, forKey: "lastNotificationTime")
    }

    // Function to retrieve the time of the last notification from local storage
    private func getLastNotificationTime() -> Date? {
        return UserDefaults.standard.object(forKey: "lastNotificationTime") as? Date
    }
    
    func hasDayPassedSinceLastNotification() -> Bool {
        guard let lastNotificationTime = getLastNotificationTime() else {
            // If no last notification time is stored, assume a day has passed
            return true
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Compare the date components of the current date and the last saved date
        let currentDay = calendar.ordinality(of: .day, in: .era, for: currentDate)
        let lastDay = calendar.ordinality(of: .day, in: .era, for: lastNotificationTime)
        
        // Check if a day has passed by comparing the day components
        if let currentDay = currentDay, let lastDay = lastDay {
            if currentDay > lastDay {
                // If the current day is greater than the last saved day, return true
                return true
            } else if currentDay < lastDay {
                // If the current day is less than the last saved day, return false
                return false
            } else {
                // If the days are the same, compare the time difference
                let components = calendar.dateComponents([.hour, .minute, .second], from: lastNotificationTime, to: currentDate)
                if let hours = components.hour, let minutes = components.minute, let seconds = components.second {
                    let timePassedInSeconds = hours * 3600 + minutes * 60 + seconds
                    // Check if more than 24 hours have passed
                    if timePassedInSeconds >= 24 * 3600 {
                        return true
                    }
                }
            }
        }
        
        return false
    }

}
