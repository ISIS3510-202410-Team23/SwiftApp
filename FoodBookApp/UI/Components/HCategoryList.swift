//
//  HCategoryList.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 25/02/24.
//

import SwiftUI

struct HCategoryList: View {
    let categories : [Category]
    let color : Color
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(categories, id: \.self){
                    cat in
                    Text(cat.name.capitalized)
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
        categories: [ Category(name: "sandwich", count: 1),  Category(name: "healthy", count: 1),  Category(name: "organic", count: 1),  Category(name: "fast", count: 2),  Category(name: "burger", count: 2),  Category(name: "low-fat", count: 1),  Category(name: "fries", count: 1)]
,
        color: Color.gray
    )
}
