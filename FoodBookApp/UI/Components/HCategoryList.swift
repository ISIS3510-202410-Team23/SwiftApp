//
//  HCategoryList.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 25/02/24.
//

import SwiftUI

struct HCategoryList: View {
    let categories : [String]
    let color : Color
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(categories, id: \.self){
                    cat in
                    Text(cat.capitalized)
                        .padding(8)
                        .background(color.opacity(0.2))
                        .cornerRadius(8)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
    }
}


#Preview {
    HCategoryList(
        categories: ["Vegan", "Sandwich", "Bowl", "Healthy", "..."],
        color: Color.gray
    )
}
