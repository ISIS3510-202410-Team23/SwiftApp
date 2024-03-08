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
    let txtSize: CGFloat
    let hPadding: CGFloat
    var action: () -> Void = { print("pressing TextButton")}
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.blue)
                .font(.system(size: txtSize))
                .padding(.horizontal, hPadding)
        }
    }
}

#Preview {
    TextButton(text: "See more", txtSize: 17, hPadding: 5, action: { print("pressing TextButton")})
}
