//
//  ContentView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/20/24.
//

import SwiftUI

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
    
    // FIXME: testing only
    let bs: BackendService =  BackendService()
    
//    init () {
//        bs.fetchAllSpots()
//    }
    
    
    var body: some View {
        
        // FIXME: sign out button for testing only
//        Button(action: {
//            Task {
//                do {
//                    print("signing out...")
//                    try AuthService.shared.signOut()
//                    showSignInView = true
//                    
//                } catch {
//                    print("Failed to sign out...")
//                }
//            }
//        }, label: {
//            Text("Sign out")
//        })
//        .buttonStyle(.borderedProminent)
//        .padding()
        
        NavigationView {
            TabView(selection: $selectedTab){
                BrowseView()
                    .tabItem { Label("Browse", systemImage: "magnifyingglass.circle") }
                    .tag(Tabs.browse)
                
                ForYouView()
                    .tabItem { Label("For you", systemImage: "star") }
                    .tag(Tabs.foryou)
                
                BookmarksView()
                    .tabItem { Label("Bookmarks", systemImage: "book") }
                    .tag(Tabs.bookmarks)
                
            }.navigationTitle(selectedTab.formattedTitle)
            
        }
    }
}

#Preview {
    ContentView(showSignInView: .constant(false))
}
