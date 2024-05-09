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
    @State private var isPresented:Bool = false
    @State private var isFetching: Bool = true
    @State private var inputHistory: [String] = []
    @State private var showOfflineAlert = false
    @State private var hasShownOfflineAlert = false
    @State private var lastAlertTime: Date? = nil

    @ObservedObject var networkService = NetworkService.shared
    
    
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
//                            TODO
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Image(systemName: "person.crop.circle")
                    })
                }
            }
            .sheet(isPresented: $isPresented) {
                UserView(showSignInView: $showSignInView)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Material.ultraThinMaterial)
                    .onDisappear {
                        let authUser = try? AuthService.shared.getAuthenticatedUser()
                        if (authUser == nil){
                            inputHistory.removeAll()
                        }
                        showSignInView = authUser == nil
                    }
            }
            .onReceive(networkService.$isOnline) { isOnline in
                if isOnline {
                    print("Network is online, initiating fetch")
                    self.isFetching = true
                    fetchData()
                    self.isFetching = false
                } else {
                    print("Network is offline, using fallback")
                    self.isFetching = true
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
            LoginView(showSignInView: $showSignInView).onDisappear() {
                fetchData()
            }
        }
    }
    
    func fetchData() {
        Task { @MainActor in
            do {
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
