//
//  BackChevron.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 29/02/24.
//

import Foundation
import SwiftUI

struct BackChevron: View {
    
    var body: some View {
        Button(action: {
            print("Redirecting to browse...") // FIXME: Should actually redirect
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .font(.system(size: 20))
            Text("Browse")
                .foregroundColor(.blue)
                .font(.system(size: 20))
        }
    }
}

#Preview {
    BackChevron()
}

