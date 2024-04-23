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
    @Binding var showSignInView: Bool
    @Binding var inputHistory: [String]
    
    @State var selectedTab: Tabs = .browse
    @State private var searchText = ""
    @State private var isPresented:Bool = false
    @State private var isFetching: Bool = true
    @State var model = ContentViewModel.shared
    @State private var bookmarksManager = BookmarksService()
    
    @ObservedObject var networkService = NetworkService.shared
    
    
    private let fileURL: URL = {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsDirectory.appendingPathComponent("inputHistory.json")
        }()
    
    
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
                BrowseView(searchText: $searchText, spots: $model.spots, isFetching: $isFetching)
                    .tabItem { Label("Browse", systemImage: "magnifyingglass.circle") }
                    .tag(Tabs.browse)
                
                ForYouView(spots: $model.forYouSpots, isFetching: $isFetching, noReviewsFlag: $model.noReviewsFlag)
                    .tabItem { Label("For you", systemImage: "star") }
                    .tag(Tabs.foryou)
                
                BookmarksView()
                    .tabItem { Label("Bookmarks", systemImage: "book") }
                    .tag(Tabs.bookmarks)
            }
            .navigationTitle(selectedTab.formattedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .modifier(SearchableModifier(isSearchable: selectedTab == .browse, text: $searchText))
            .searchSuggestions({
                if searchText.isEmpty {
                    ForEach(inputHistory.indices, id: \.self) { index in
                        let text = inputHistory[index]
                        Text("\(Image(systemName: "clock"))\t\(text)")
                            .foregroundColor(.secondary)
                    }
                    if !inputHistory.isEmpty {
                        Button(action: {
                            inputHistory.removeAll()
                            if let data = try? JSONEncoder().encode(inputHistory) {
                                try? data.write(to: fileURL)
                            }
                        }) {
                            Text("Clear History")
                        }
                    }
                }
            })
            .onSubmit(of: .search) {
                if searchText != "" {
                    print("Submitted: \(searchText)")
                    if inputHistory.count >= 10 {
                        inputHistory.removeLast()
                    }
                    inputHistory.insert(searchText, at: 0)
                    if let data = try? JSONEncoder().encode(inputHistory) {
                        try? data.write(to: fileURL)
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
                        showSignInView = authUser == nil
                    }
            }
            .onReceive(networkService.$isUnavailable) { isUnavailable in
                if !isUnavailable {
                    Task {
                        self.isFetching = true
                        do {
                            try await model.fetch()
                        } catch {
                            print("ERROR: Fetching \(error)")
                        }
                        self.isFetching = false
                    }
                } else {
                    self.isFetching = true
                    self.model.fallback()
                    self.isFetching = false
                }
                
            }
            .environment(bookmarksManager)
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
