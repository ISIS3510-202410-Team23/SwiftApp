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
    let distance : String
    let categories : [Category]
    let imageLinks : [String]
    let price : String
    
    let rowLayout = Array(repeating: GridItem(), count: 2)
    
    @State var selected = false
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyHGrid(rows: rowLayout, alignment: .top, spacing: 8, content: {
                ForEach(imageLinks, id: \.self){
                    image in
                    AsyncImage(url: URL(string: image)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                      } placeholder: {
                          ProgressView()
                      }
                      .frame(width: 110, height: 80)
                      .cornerRadius(10)
                        
                }
            })
            HStack {
                Text("\(title) · \(price) ")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    selected.toggle()
                }, label: {
                    Image(systemName: selected ? "bookmark.fill" : "bookmark").imageScale(.large).bold()
                })
                .buttonStyle(.plain)
            }
            Text("\(Image(systemName: "clock")) \(minTime)-\(maxTime) min.   \(Image(systemName: "location")) \(distance) km")
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
        distance: "99+",
        categories:[ Category(name: "sandwich", count: 1),  Category(name: "healthy", count: 1),  Category(name: "organic", count: 1),  Category(name: "fast", count: 2),  Category(name: "burger", count: 2),  Category(name: "low-fat", count: 1),  Category(name: "fries", count: 1)]
,
        imageLinks: [
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=2380&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://images.unsplash.com/photo-1493770348161-369560ae357d?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://images.unsplash.com/photo-1498837167922-ddd27525d352?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://images.unsplash.com/photo-1473093295043-cdd812d0e601?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            "https://images.unsplash.com/photo-1529042410759-befb1204b468?q=80&w=2486&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        ],
        price: "$"
        
    )
}
