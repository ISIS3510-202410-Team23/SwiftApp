//
//  ReviewsView.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 27/02/24.
//

import Foundation
import SwiftUI


struct ReviewsView: View {
    //    @State private var model = ReviewsViewModel()
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let spotName : String
    let reviews: [Review]
    
    @ObservedObject var networkService = NetworkService.shared
    private let utils = Utils.shared
    
    @State private var model = ReviewsViewModel()
    
    var body: some View {
        
        // Header
        VStack(spacing: 0){
            if !networkService.isOnline {
                VStack {
                    HStack() {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        Text("offline")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(4)
                }
            }
            
            // Reviews
            if !reviews.isEmpty {
                NavigationStack {
                    ScrollView(.vertical) {
                        VStack {
                            ForEach(reviews.reversed(), id: \.self) { review in
                                ReviewCard(review: review, userId: model.username)
                            }.padding(.vertical, 5)
                        }
                        .padding()
                    }
                }
            } else {
                Spacer()
                Text("No reviews, yet...")
                Spacer()
            }
        }.task {
            _ = try? await model.getUserInfo()
        }
    }
}

#Preview {
    ReviewsView(spotName: "MiCaserito", reviews: [
        Review(
            content: "Lo digo y lo insisto, mi caserito es el restaurante más completo de los andes.",
            date: Date(),
            imageUrl: "https://i.ytimg.com/vi/1n6bq4wfoSU/hq720.jpg?sqp=-oaymwEXCK4FEIIDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLCCW-rqYpxNt3xW3Ag43ns--EwGLw",
            ratings: ReviewStats(cleanliness: 5, foodQuality: 5, service: 5, waitTime: 4),
            selectedCategories: ["Homemade", "Dessert"],
            title: "Me fascina!!",
            user: UserInfo(id: "juan.pg", name: "Juan Pedro Gonzalez") // TODO: will be user uid, might need to add antoher field for email
        ),
        Review(
            content: "La comida me gustó pero la atención fue pésima, se demoró muchísimo, lástima.",
            date: Date(),
            imageUrl: nil,
            ratings: ReviewStats(cleanliness: 2,
                                 foodQuality: 3,
                                 service: 1,
                                 waitTime: 1),
            
            selectedCategories: ["Poultry", "Rice", "Soup"],
            title: "No lo recomiendo.",
            user: UserInfo(id: "mmz", name:"Mariana Martínez")
        )
        
    ])
    
}
