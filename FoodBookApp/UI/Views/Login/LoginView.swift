//
//  LoginView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/24/24.
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import BackgroundTasks

@MainActor
struct LoginView: View {
    
    @State private var viewModel = LoginViewModel()
    @Binding var showSignInView: Bool
    @ObservedObject var locationService = LocationService.shared
    @ObservedObject var networkService = NetworkService.shared
    
    let notify = NotificationHandler()
    
    
    var body: some View {
        VStack {
            
            // Application Name
            HStack {
                Text("foodbook")
                    .font(.custom("ArchivoBlack-Regular", size: 48))
                    .frame(alignment: .leading) // Aligns the text to the leading edge (left side)
                    .padding(.leading) // Adds padding to the leading edge (left side)
                Spacer()
            }
            
            // Welcome page logo
            Image("toasty")
                .resizable()
                .scaledToFit()
                .padding()
            
            // Application Tagline
            HStack{
                Text("Where good people find good food.") // TODO: i18n string
                    .font(.system(size: 30, weight: .regular, design: .default))
                    .frame(alignment: .leading) // Aligns the text to the leading edge (left side)
                    .padding(.leading) // Adds padding to the leading edge (left side)
                Spacer()
            }
            .padding(.bottom, 30)
            
            // Button to log in
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    await viewModel.signInGoogle()
                    
                    if !viewModel.showAlert {
                        print("Successful sign in.")
                        showSignInView = false
                        notify.askPermission() // This will only be done once, not every time a user signs in
                        notify.sendLastReviewNotification(date: Date())
                        
                        if locationService.userLocation == nil{
                            locationService.requestLocationAuthorization()
                            schedule()
                        }
                    }
                }
                
            }
            .disabled(networkService.isUnavailable || networkService.isLowConnection)
            .padding()
            .colorMultiply(networkService.isUnavailable ? .gray : .white)
            .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorTitle)
            }
            
            if(networkService.isUnavailable) {
                Text("No connection, please make sure you have internet access before attempting to log-in")
                    .foregroundStyle(.red)
            }
            
            if(networkService.isLowConnection) {
                Text("Your connection is low, please make sure you have internet access before attempting to log-in")
                    .foregroundStyle(.red)
            }
            
            // Keeping old Button code for reference
            
            //            Button(action: {
            //                    print("Login in...")
            //                }, label: {
            //                    Image("uniandes-logo")
            //                        .resizable()
            //                       .frame(width: 25, height: 25)
            //                    Text("Continue with Uniandes")
            //                        .frame(maxWidth: .infinity)
            //                        .padding(.vertical, 5)
            //                })
            //            .buttonStyle(.borderedProminent)
            //            .padding()
        }
        .padding()
    }
}

private func schedule () {
    let taskId = "Team23.FoodBookApp.contextTask"
    
    // Manual Test: e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"Team23.FoodBookApp.contextTask"]
    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskId)
    BGTaskScheduler.shared.getPendingTaskRequests { request in
        print("\(request.count) tasks pending...")
        
        // Don't schedule repeated tasks
        guard request.isEmpty else {
            return
        }
        
        // Submit a task to be scheduled
        do {
            let newTask = BGAppRefreshTaskRequest(identifier: taskId)
//            newTask.earliestBeginDate = Calendar.current.date(bySettingHour: 12, minute: 10 , second: 0, of: Date())! // Wont execute before said hour.
            newTask.earliestBeginDate =  Date().addingTimeInterval(120) // Testing - in theory every 2 minutes
            try BGTaskScheduler.shared.submit(newTask)
            print("Submitted task...")
        } catch {
            print("Could not submit task to be scheduled. \(error.localizedDescription)")
        }
    }
}

#Preview {
    LoginView(showSignInView: .constant(true))
}
