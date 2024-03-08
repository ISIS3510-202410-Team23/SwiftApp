//
//  BookmarksView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BookmarksView: View {
    
    let bs: BackendService = BackendService()
    
    var body: some View {
        
        ZStack {
            // FIXME: the following content is temporary
            Image(systemName: "book")
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .font(.system(size: 100))
        }
        .task {
            do {
                try await bs.spotRepo.getSpotById(docId: "ms1hTTxzVkiJElZiYHAT")
            } catch {
                print("ERROR")
            }
        }

    }
}

#Preview {
    BookmarksView()
}
