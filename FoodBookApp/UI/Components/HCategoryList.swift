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
    
    // FIXME: could function better with a lot of categories
    var body: some View {
        HStack {
            ForEach(categories, id: \.self){
                cat in 
                Text(cat)
                    .padding(8)
                    .background(color.opacity(0.2))
                    .cornerRadius(8)
                    .lineLimit(1)
                    .truncationMode(.tail)
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
