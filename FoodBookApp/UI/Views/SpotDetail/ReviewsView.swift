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
    
    var body: some View {
        
        // Header
        VStack(spacing: 0){
            //            ZStack(alignment: .leading) {
            //                TextButton(text: "Cancel", txtSize: 20, hPadding: 0)
            //                Text(spotName)
            //                    .bold()
            //                    .frame(maxWidth: .infinity, alignment: .center)
            //                    .font(.system(size: 20))
            //            }.padding()
            
            //            Separator()
            Rectangle()
                .fill(Color.gray)
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
            ScrollView(.vertical) {
                
                // Reviews
//                VStack {
//                    ForEach(reviews, id: \.self) { review in
//                        VStack {
//                            Text(review.date.formatted())
//                            Text(review.selectedCategories.joined(separator: ", "))
//                            if review.title != nil {
//                                Text(review.title)
//                            }
//                        }
//                        
//                    }
//                }
                VStack {
                    ForEach(reviews, id: \.self) { review in
                        ZStack {
                            Rectangle()
                                .fill(customGray)
                                .cornerRadius(15)
                            VStack(spacing: 0) {
                                HStack {
                                    if review.title != nil {
                                        Text(review.title).bold()
                                    }
                                    Spacer()
                                    Text(DateFormatter.localizedString(from: review.date, dateStyle: .short, timeStyle: .none)).foregroundColor(.gray) // FIXME: should calculate time (?)
                                }.padding()
                                HStack {
                                    Spacer()
                                    Text(review.user)
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
                                            Text(tag)
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
                                    if review.content != nil {
                                        Text(review.content)
                                    }
                                    if review.imageUrl != nil {
                                        Spacer()
                                        AsyncImage(url: URL(string: review.imageUrl)) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                    }
                                    
                                }.padding()
                            }
                        }
                    }.padding(.vertical, 5)
                }
                .padding()
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
                user: "Juan Pedro Gonzalez" // TODO: will be user uid, might need to add antoher field for email
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
                    user: "Mariana Martínez"
            )
            
        ])

}
