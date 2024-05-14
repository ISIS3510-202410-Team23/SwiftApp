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
    @State private var showSignInView: Bool = {
        let authUser = try? AuthService.shared.getAuthenticatedUser()
        return authUser == nil
    }()
    
    @State private var model = ContentViewModel.shared
    @State private var bookmarksManager = BookmarksService()
    @State private var selectedTab: Tabs = .browse
    @State private var searchText = ""
    @State private var isUserSheetPresented:Bool = false
    @State private var isSettingsSheetPresented: Bool = false
    @State private var isFetching: Bool = true
    @State private var inputHistory: [String] = []
    @State private var showOfflineAlert = false
    @State private var hasShownOfflineAlert = false
    @State private var lastAlertTime: Date? = nil

    @ObservedObject var networkService = NetworkService.shared
    @ObservedObject var dbManager = DBManager.shared
    
    var body: some View {
        NavigationStack {
            if !networkService.isOnline {
                HStack(spacing: 4) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Text("offline")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(4)
            }
            
//            DEBUG:
//            Text("Browse spots: Cached \(model.browseSpotsCached.count), List \(model.browseSpots.count) ")
//            Text("For You spots: List \(model.forYouSpots.count)")
//            Text("No reviews flag: \(model.noReviewsFlag ? "true" : "false")")
//            Text("Is fetching flag: \(isFetching ? "true" : "false")")
            
            TabView(selection: $selectedTab){
                
                BrowseView(searchText: $searchText, spots: networkService.isOnline ? $model.browseSpots : $model.browseSpotsCached, isFetching: $isFetching)
                    .tabItem { Label("Browse", systemImage: "magnifyingglass.circle") }
                    .tag(Tabs.browse)
                
                ForYouView(spots: $model.forYouSpots, isFetching: $isFetching, noReviewsFlag: $model.noReviewsFlag)
                    .tabItem { Label("For you", systemImage: "star") }
                    .tag(Tabs.foryou)
                
                BookmarksView()
                    .tabItem { Label("Bookmarks", systemImage: "book") }
                    .tag(Tabs.bookmarks)
                
            }
            .onAppear {
                self.inputHistory = model.loadInputHistory()
                Task {
                    if networkService.isOnline && !dbManager.uploading {
                        do {
                            try await DBManager.shared.uploadReviews()
                        } catch {
                            print("Error uploading reviews: ", error.localizedDescription)
                        }
                    }
                }
            }
            .onChange(of: networkService.isOnline) {
                Task {
                    if networkService.isOnline && !dbManager.uploading {
                        do {
                            try await DBManager.shared.uploadReviews() 
                        } catch {
                            print("Error uploading reviews: ", error.localizedDescription)
                        }
                    }
                }
            }
            .navigationTitle(selectedTab.formattedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .modifier(SearchableModifier(isSearchable: selectedTab == .browse, text: $searchText))
            .searchSuggestions({
                if searchText.isEmpty {
                    ForEach(inputHistory.indices, id: \.self) { index in
                        let text = inputHistory[index]
                        Button {
                            self.searchText = text
                        } label: {
                            Text("\(Image(systemName: "clock"))\t\(text)")
                                .foregroundColor(.secondary)
                        }
                    }
                    if !inputHistory.isEmpty {
                        let saved = self.inputHistory
                        Button(action: {
                            Task {
                                try await model.saveSearchItems(items: saved)
                            }
                            inputHistory.removeAll()
                            do {
                                try model.writeInputHistory(inputHistory: self.inputHistory)
                            } catch {
                                print(error)
                            }
                        }) {
                            Text("Clear History")
                        }
                    }
                }
            })
            .onSubmit(of: .search) {
                if searchText != "" && !inputHistory.contains(searchText) {
                    print("Submitted: \(searchText)")
                    if inputHistory.count >= 10 {
                        inputHistory.removeLast()
                    }
                    inputHistory.insert(searchText, at: 0)
                    do {
                        try model.writeInputHistory(inputHistory: self.inputHistory)
                    } catch {
                        print(error)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            isSettingsSheetPresented.toggle()
                        }) {
                            Image(systemName: "gear")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isUserSheetPresented.toggle()
                        }) {
                            Image(systemName: "person.crop.circle")
                        }
                    }
            }
            .sheet(isPresented: $isUserSheetPresented) {
                UserView(showSignInView: $showSignInView)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Material.ultraThinMaterial)
                    .onDisappear {
                        let authUser = try? AuthService.shared.getAuthenticatedUser()
                        showSignInView = authUser == nil
                        if (showSignInView) { // moved after so it's done in the background
                            inputHistory.removeAll()
                            self.bookmarksManager.cleanup()
                        }
                    }
            }
            .sheet(isPresented: $isSettingsSheetPresented) {
                SettingsView()
            }
            .onReceive(networkService.$isOnline) { isOnline in
                self.isFetching = true
                if isOnline {
                    print("Network is online, initiating fetch")
                    fetchData()
                } else {
                    print("Network is offline, using fallback")
                    self.model.fallback()
                    let currentTime = Date()
                    if let lastAlertTime = lastAlertTime, currentTime.timeIntervalSince(lastAlertTime) < 30 {
                        self.isFetching = false
                    } else {
                        showOfflineAlert = true
                        lastAlertTime = currentTime
                        hasShownOfflineAlert = true
                        self.isFetching = false
                    }
                }
            }
            .alert(isPresented: $showOfflineAlert, content: {
                Alert(
                    title: Text("No internet connection"),
                    message: Text("Please check your internet connection and try again."),
                    dismissButton: .default(Text("OK")) {
                        self.showOfflineAlert = false
                    }
                )
            })
            .environment(bookmarksManager)
        }
        .fullScreenCover(isPresented: $showSignInView) {
            LoginView(showSignInView: $showSignInView)
            .onAppear() {
                self.selectedTab = .browse
            }
            .onDisappear() {
                self.isFetching = true
                fetchData()
            }
        }
    }
    
    func fetchData() {
        Task { @MainActor in
            do {
                self.bookmarksManager = BookmarksService()
                try await model.fetch()
            } catch {
                print("Fetch error: \(error)")
            }
            self.isFetching = false
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

//
//#Preview {
//    ContentView(showSignInView: .constant(false))
//}
