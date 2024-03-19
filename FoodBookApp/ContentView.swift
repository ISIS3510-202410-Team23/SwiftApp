//
//  ContentView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/20/24.
//

import SwiftUI
import BackgroundTasks

enum Tabs:String {
    case browse
    case foryou
    case bookmarks
    
    var formattedTitle: String {
        switch self {
        case .browse: return "Browse"
        case .foryou: return "For you"
        case .bookmarks: return "Bookmarks"
        }
    }
}

struct ContentView: View {
    @State var selectedTab: Tabs = .browse
    @Binding var showSignInView: Bool
    @State private var searchText = ""
    @ObservedObject var locationService = LocationService.shared
    
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab){
                BrowseView(searchText: $searchText)
                    .tabItem { Label("Browse", systemImage: "magnifyingglass.circle") }
                    .tag(Tabs.browse)
                    .onAppear{
                        if locationService.userLocation == nil {
                            locationService.requestLocationAuthorization()
                            schedule()
                        }
                    }
                
                ForYouView()
                    .tabItem { Label("For you", systemImage: "star") }
                    .tag(Tabs.foryou)
                
                BookmarksView(showSignInView: $showSignInView)
                    .tabItem { Label("Bookmarks", systemImage: "book") }
                    .tag(Tabs.bookmarks)
            }
            .navigationTitle(selectedTab.formattedTitle)
            .modifier(SearchableModifier(isSearchable: selectedTab == .browse, text: $searchText))
        }
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

struct SearchableModifier: ViewModifier {
    let isSearchable: Bool
    @Binding var text: String

    func body(content: Content) -> some View {
        if isSearchable {
            return content
                .searchable(text: $text)
                .eraseToAnyView()
        } else {
            return content.eraseToAnyView()
        }
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}

#Preview {
    ContentView(showSignInView: .constant(false))
}
