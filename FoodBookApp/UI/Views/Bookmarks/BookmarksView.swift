//
//  BookmarksView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI
import LocalAuthentication

struct BookmarksView: View {
    
    @State var bookmarksManager = BookmarksService.shared
    
    var body: some View {
        
        if !bookmarksManager.savedBookmarkIds.isEmpty {
            Text("You have \(bookmarksManager.savedBookmarkIds.count) saved spot.")
//            ForEach(Array(bookmarksManager.savedBookmarkIds), id: \.self) { spotId in
//                Text(spotId)
//            }
        } else {
            VStack {
                Image(systemName: "book")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 100))
                Text("You have no saved bookmarks.")
            }
        }
        
        
    }
}

#Preview {
    BookmarksView()
}
