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
    @State private var isPresented:Bool = false
    @State private var isFetching: Bool = true
    
    @ObservedObject var networkService = NetworkService.shared
    @State var model = ContentViewModel.shared
    
   
    @State private var bookmarksManager = BookmarksService()
    
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
                
                ForYouView(spots: networkService.isOnline ? $model.forYouSpots : $model.forYouSpotsCached, isFetching: $isFetching, noReviewsFlag: $model.noReviewsFlag)
                    .tabItem { Label("For you", systemImage: "star") }
                    .tag(Tabs.foryou)
                
                BookmarksView()
                    .tabItem { Label("Bookmarks", systemImage: "book") }
                    .tag(Tabs.bookmarks)
            }
            .navigationTitle(selectedTab.formattedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .modifier(SearchableModifier(isSearchable: selectedTab == .browse, text: $searchText))
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
            .onReceive(networkService.$isOnline) { _ in
                if networkService.isOnline {
                    print("Network is online, initiating fetch")
                    Task { @MainActor in
                        self.isFetching = true
                        do {
                            try await model.fetch()
                        } catch {
                            print("Fetch error: \(error)")
                        }
                        self.isFetching = false
                    }
                } else {
                    print("Network is offline, using fallback")
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
