//
//  SpotCard.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 25/02/24.
//

import SwiftUI

struct SpotCard: View {
    // TODO: Missing bookmarking feature
    
    let title : String
    let minTime : Int
    let maxTime : Int
    let distance : Float
    let categories : [String]
    let colors: [Color]  // TODO: temporary
    
    let rowLayout = Array(repeating: GridItem(), count: 2)
    
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyHGrid(rows: rowLayout, alignment: .top, spacing: 8, content: {
                ForEach(colors.indices, id: \.self){
                    index in 
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 110, height: 80)
                        .foregroundColor(colors[index]) // TODO: should be images not colours
                }
            })
            Text(title)
                .font(.title)
                .bold()
            Text("\(Image(systemName: "clock")) \(minTime)-\(maxTime) min.   \(Image(systemName: "location")) \(distance.formatted()) km")
            HCategoryList(categories: categories, color: Color.gray)
        }
        .padding(.all)
        .cornerRadius(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
    
}

#Preview {
    SpotCard(
        title: "Divino Pecado",
        minTime: 25,
        maxTime: 30,
        distance: 0.5,
        categories: ["Vegan", "Sandwich", "Bowl", "Healthy", "..."],
        colors: [.cyan, .indigo, .teal, .pink, .mint, .purple]
        
    )
}
