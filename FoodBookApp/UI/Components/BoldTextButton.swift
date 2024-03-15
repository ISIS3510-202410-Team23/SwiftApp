//
//  TextButton.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 29/02/24.
//

import Foundation
import SwiftUI

struct BoldTextButton: View {
    
    let text: String
    let txtSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.blue)
                .font(.system(size: txtSize))
                .bold()
        }
    }
}

#Preview {
    BoldTextButton(text: "Done", txtSize: 20){ print("Done") }
}
