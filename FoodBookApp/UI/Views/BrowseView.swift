//
//  BrowseView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 21/02/24.
//

import SwiftUI

struct BrowseView: View {
    // FIXME: maybe all of these parameters should come from the API?
    struct Spot: Hashable {
        let name: String
        let minTime: Int
        let maxTime: Int
        let distance: Double
        let categories: [String]
    }
       
    
    let spots: [Spot] = [
        Spot(
            name: "Mi Caserito",
            minTime: 10,
            maxTime: 20,
            distance: 0.3,
            categories: ["Fast", "Homemade", "Colombian", "..."]
        ),
        Spot(
            name: "Divino Pecado",
            minTime: 25,
            maxTime: 30,
            distance: 0.5,
            categories: ["Vegan", "Sandwich", "Bowl", "Healthy", "..."]
        )
    ]
    
    var body: some View {
        // TODO: Missing searchbar for spots
        // TODO: Missing filter for categories
        ScrollView(content: {
            ForEach(spots, id: \.self){
                spot in
                SpotCard(
                    title: spot.name,
                    minTime: spot.minTime,
                    maxTime: spot.maxTime,
                    distance: Float(spot.distance),
                    categories: spot.categories
                )
                .fixedSize(horizontal: false, vertical: true)
            }
        }).padding(8)
    }
}

#Preview {
    BrowseView()
}
