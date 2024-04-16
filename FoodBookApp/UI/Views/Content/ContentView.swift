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
   
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab){
                BrowseView(searchText: $searchText)
                    .tabItem { Label("Browse", systemImage: "magnifyingglass.circle") }
                    .tag(Tabs.browse)
                ForYouView()
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
