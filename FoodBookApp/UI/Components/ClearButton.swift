//
//  ClearButton.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 4/03/24.
//

import Foundation
import SwiftUI

struct ClearButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "multiply.circle.fill")
                .foregroundStyle(.gray)
        }
    }

}

#Preview {
    ClearButton(){ print("Clearing...") }
}
