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
    @State private var showAlert:Bool = false
    @State private var isFetching: Bool = true
        
    @ObservedObject var networkService = NetworkService.shared
    @State var model = ContentViewModel.shared
    
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab){
                BrowseView(searchText: $searchText, spots: $model.spots, isFetching: $isFetching)
                    .tabItem { Label("Browse", systemImage: "magnifyingglass.circle") }
                    .tag(Tabs.browse)
                
                ForYouView(spots: $model.forYouSpots, isFetching: $isFetching)
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
            .alert("Please check your internet connection and try again", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            .onReceive(networkService.$isOnline) { isOnline in
                if !isOnline {
                    self.showAlert = true
                    self.isFetching = true
                    
                    Task {
                        do {
                            try await model.fallback()
                            self.isFetching = false
                        } catch {
                            print("ERROR: Fetching from cache failed \(error)")
                        }
                    }
                } else if isOnline {
                    self.showAlert = false
                    Task {
                        self.isFetching = true
                        
                        do {
                            try await model.fetch()
                        }
                        catch {
                            print("ERROR: Fetching \(error)")
                        }
                        
                        self.isFetching = false
                    }
                }
            }

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
