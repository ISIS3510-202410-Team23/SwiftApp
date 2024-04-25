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
    
    var body: some View {
        
        // Header
        VStack(spacing: 0){
            // Sheet rectangle
            Rectangle()
                .fill(Color.gray)
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
            
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
            
            if !reviews.isEmpty {
                ScrollView(.vertical) {
                    
                    // Reviews
                    VStack {
                        ForEach(reviews.reversed(), id: \.self) { review in
                            ZStack {
                                Rectangle()
                                    .fill(customGray)
                                    .cornerRadius(15)
                                VStack(spacing: 0) {
                                    HStack {
                                        if review.title != nil && review.title != "" {
                                            Text(review.title).bold()
                                        } else {
                                            Text("No title.").foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(DateFormatter.localizedString(from: review.date, dateStyle: .short, timeStyle: .none)).foregroundColor(.gray)
                                    }.padding()
                                    HStack {
                                        Spacer()
                                        Text(review.user.name ?? "-")
                                            .foregroundColor(.gray)
                                    }.padding(.horizontal, 10)
                                    
                                    
                                    // Quality attributes
                                    ZStack(alignment: .leading){
                                        Rectangle()
                                            .fill(Color.white)
                                            .cornerRadius(15)
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("Cleanliness")
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    ForEach(1..<6) { index in Image(systemName: "star.fill").foregroundColor(review.ratings.cleanliness >= index ? .yellow : .gray)}
                                                }
                                            }
                                            HStack {
                                                Text("Waiting time")
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    ForEach(1..<6) { index in Image(systemName: "star.fill").foregroundColor(review.ratings.waitTime >= index ? .yellow : .gray)}
                                                }
                                            }
                                            HStack {
                                                Text("Service")
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    ForEach(1..<6) { index in Image(systemName: "star.fill").foregroundColor(review.ratings.service >= index ? .yellow : .gray)}
                                                }
                                            }
                                            HStack {
                                                Text("Food quality")
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    ForEach(1..<6) { index in Image(systemName: "star.fill").foregroundColor(review.ratings.foodQuality >= index ? .yellow : .gray)}
                                                }
                                            }
                                        }.padding()
                                    }.padding()
                                    
                                    // Categories
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(review.selectedCategories, id: \.self) { tag in
                                                Text(tag.capitalized)
                                                    .font(.system(size: 14))
                                                    .bold()
                                                    .foregroundColor(.black)
                                                    .padding(10)
                                                    .background(Color.white)
                                                    .cornerRadius(8)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    
                                    // Review body and image
                                    HStack {
                                        if review.content != nil && review.content != "" {
                                            Text(review.content)
                                        } else {
                                            Text("No description.").foregroundColor(.gray)
                                        }
                                        if review.imageUrl != nil {
                                            Spacer()
                                            if networkService.isOnline {
                                                AsyncImage(url: URL(string: review.imageUrl)) { image in
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .frame(width: 70, height: 70)
                                                .cornerRadius(10)
                                                
                                            } else {
                                                Image("no-image")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 70, height: 70)
                                                    .cornerRadius(10)
                                            }
                                        }                                        
                                    }.padding()
                                }
                            }
                        }.padding(.vertical, 5)
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text("No reviews, yet...")
                Spacer()
            }
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
