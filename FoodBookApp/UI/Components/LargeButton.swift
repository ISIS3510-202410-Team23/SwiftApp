//
//  LargeButton.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 29/02/24.
//

import Foundation
import SwiftUI

struct LargeButton: View {
    
    let text: String
    let bgColor: Color
    let txtColor: Color
    let txtSize: CGFloat
    
    var body: some View {
        Button(action: {
                print("LargeButton action...") // FIXME: Should do action
            }, label: {
                Text(text)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(bgColor)
                    .foregroundColor(txtColor)
                    .cornerRadius(12)
                    .font(.system(size: txtSize))
        }).padding()
    }
}

#Preview {
    LargeButton(text: "Leave a review", bgColor: Color.blue, txtColor: Color.white, txtSize: 20)
}
