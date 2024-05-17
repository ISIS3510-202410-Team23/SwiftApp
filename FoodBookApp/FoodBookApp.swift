//
//  FoodBookAppApp.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/20/24.
//

import SwiftUI
import FirebaseCore
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let taskId = "Team23.FoodBookApp.contextTask"
    let notify = NotificationHandler()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        
        // Register Hanlder for task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            // Handle task when its run
            guard let task = task as? BGAppRefreshTask else { return }
            self.handleTask(task: task)
        }
                
        notify.askPermission()
        
        return true
    }
    
    private func handleTask(task: BGAppRefreshTask) {
        print("time: \(Utils.shared.isWithinLunchWindow()), location: \(LocationService.shared.userInRegion(regionId: "uniandes"))")
        if Utils.shared.isWithinLunchWindow() && LocationService.shared.userInRegion(regionId: "uniandes") {
            print("Sending context aware notification...")
            NotificationHandler().sendLunchTimeReminder(identifier: "lunchTime")
            task.setTaskCompleted(success: true)
        } else {
            print("Not yet...")
//            task.setTaskCompleted(success: false)
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // Update the app interface directly.
        
        // Show a banner
        completionHandler([.banner, .sound])

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Clear the state in UserDefaults when the app is about to terminate
        UserDefaults.standard.removeObject(forKey: "hideHotCategories")
    }
    
    
}

@main
struct FoodBookApp: App {
    //  register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
