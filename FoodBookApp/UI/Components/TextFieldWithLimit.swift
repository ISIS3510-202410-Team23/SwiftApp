//
//  TextFieldWithLimit.swift
//  FoodBookApp
//
//  Created by Maria Castro on 5/11/24.
//

import SwiftUI
import Combine

struct TextFieldWithLimit: View {
    
    @State private var charCount: Int = 0
    @Binding var textContent: String
    var title: String
    var charLimit: Int
    
    var body: some View {
        VStack {
            TextField(title, text: $textContent,  axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...5)
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: true)
                .onReceive(Just(textContent)) { _ in limitText(charLimit) }
            HStack {
                Spacer()
                Text("\(charCount.formatted())/\(charLimit.formatted())")
                    .font(.caption)
                    .foregroundStyle(charCount >= charLimit ? .red : .black)
            }
        }
    }
    
    func limitText(_ upper: Int) {
        if textContent.count > upper {
            textContent = String(textContent.prefix(upper))
        }
        charCount = textContent.count
    }
}

#Preview {
    TextFieldWithLimit(textContent: .constant("text"), title: "Testing the Field", charLimit: 180)
}
