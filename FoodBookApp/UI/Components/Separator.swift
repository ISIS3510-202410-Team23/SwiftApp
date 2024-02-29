//
//  Separator.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 29/02/24.
//

import Foundation
import SwiftUI

struct Separator: View {
    
    var body: some View {
        Rectangle()
            .fill(.gray).frame(height: 0.5)
    }
}

#Preview {
    Separator()
}
