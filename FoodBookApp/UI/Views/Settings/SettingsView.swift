//
//  SettingsView.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 11/05/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @State private var daysSinceLastReview = UserDefaults.standard.bool(forKey: "sendDaysSinceLastReviewNotification")
    @State private var days = UserDefaults.standard.integer(forKey: "daysSinceLastReview") - 1
    @State private var reviewsUploaded = UserDefaults.standard.bool(forKey: "sendReviewsUploadedNotification")
    @State private var lunchTime = UserDefaults.standard.bool(forKey: "sendLunchTimeNotification")
    
    @State private var authenticateReviews = UserDefaults.standard.bool(forKey: "authenticateBeforeUploading")
    
    let customGray2 = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        VStack() {
            // Header
            Text("Settings")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
            
            Separator()
            
            Form {
                // MARK: - Notification Settings
                Section(header: Text("NOTIFICATIONS")) {
                    Toggle("Days since last review", isOn: $daysSinceLastReview)
                        .onChange(of: daysSinceLastReview) {
                            UserDefaults.standard.set(daysSinceLastReview ? true : false, forKey: "sendDaysSinceLastReviewNotification")
                            if (daysSinceLastReview && UserDefaults.standard.object(forKey: "daysSinceLastReview") == nil) {
                                days = 3
                                UserDefaults.standard.set(4, forKey: "daysSinceLastReview")
                            }
                        }
                    if daysSinceLastReview {
                        Picker("Number of days", selection: $days) {
                            ForEach(1..<8) { day in
                                Text("\(day) \(day == 1 ? "day" : "days")")
                            }
                        }.onChange(of: days) {
                            UserDefaults.standard.set(days + 1, forKey: "daysSinceLastReview")
                        }
                    }
                    Toggle("Reviews uploaded", isOn: $reviewsUploaded)
                        .onChange(of: reviewsUploaded) {
                            UserDefaults.standard.set(reviewsUploaded ? true : false, forKey: "sendReviewsUploadedNotification")
                        }
                    Toggle("Lunch time", isOn: $lunchTime)
                        .onChange(of: lunchTime) {
                            UserDefaults.standard.set(lunchTime ? true : false, forKey: "sendLunchTimeNotification")
                        }
                }
                
                // MARK: - Authentication Settings
                Section(header: Text("AUTHENTICATION")) {
                    Toggle("Authenticate before uploading reviews", isOn: $authenticateReviews)
                        .onChange(of: authenticateReviews) {
                            UserDefaults.standard.set(authenticateReviews, forKey: "authenticateBeforeUploading")
                        }
                }
            }
            Spacer()
            Text("auth \(authenticateReviews ? "yes" : "no")")
        }.background(customGray2)
    }
}

//#Preview {
//    SettingsView()
//}
