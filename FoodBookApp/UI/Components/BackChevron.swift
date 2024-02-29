//
//  BackChevron.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 29/02/24.
//

import Foundation
import SwiftUI

struct BackChevron: View {
    
    let text: String
    
    var body: some View {
        Button(action: {
            print("BackChevron action...") // FIXME: Should do action
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .font(.system(size: 20))
            Text(text)
                .foregroundColor(.blue)
                .font(.system(size: 20))
        }
    }
}

#Preview {
    BackChevron(text: "Browse")
}

