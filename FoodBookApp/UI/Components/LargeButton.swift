//
//  LargeButtont.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 5/03/24.
//

import Foundation
import SwiftUI

struct LargeButton: View {
    
    let text: String
    let bgColor: Color
    let txtColor: Color
    let txtSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
                Text(text)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(bgColor)
                    .foregroundColor(txtColor)
                    .cornerRadius(12)
                    .font(.system(size: txtSize))
        }.padding()
    }
}

#Preview {
    LargeButton(text: "Leave a review", bgColor: Color.blue, txtColor: Color.white, txtSize: 20){ print("Leave a review") }
}
