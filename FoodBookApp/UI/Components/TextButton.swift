//
//  TextButton.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 29/02/24.
//

import Foundation
import SwiftUI

struct TextButton: View {
    
    let text: String
    
    var body: some View {
        Button(action: {
            print("Redirecting to reviews...") // FIXME: Should actually redirect
        }) {
            Text("See more")
                .foregroundColor(.blue)
                .font(.system(size: 17))
                .padding(.horizontal, 5)
        }
    }
}

#Preview {
    TextButton(text: "See more")
}
