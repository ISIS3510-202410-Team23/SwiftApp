//
//  ReviewsView.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 27/02/24.
//

import Foundation
import SwiftUI

struct Review: Hashable {
    let cleanliness: Int
    let waitingTime: Int
    let service: Int
    let foodQuality: Int
    let tags: [String]
    let description: String
    let title: String
    let photo: String
    let user: String
    let date: Date
}

struct ReviewsView: View {
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let reviews: [Review] = [Review(cleanliness: 5,
                                    waitingTime: 4,
                                    service: 5,
                                    foodQuality: 5,
                                    tags: ["Homemade", "Dessert"],
                                    description: "Lo digo y lo insisto, mi caserito es el restaurante más completo de los andes.",
                                    title: "Me fascina!!",
                                    photo: "homemade-lunch",
                                    user: "Juan Pedro Gonzalez",
                                    date: Date()),
                             Review(cleanliness: 2,
                                     waitingTime: 1,
                                     service: 1,
                                     foodQuality: 3,
                                     tags: ["Poultry", "Rice", "Soup"],
                                     description: "La comida me gustó pero la atención fue pésima, se demoró muchísimo, lástima.",
                                     title: "No lo recomiendo.",
                                     photo: "",
                                     user: "Mariana Martínez",
                                     date: Date())] // FIXME: should be spot's reviews
    
    var body: some View { 
        ScrollView(.vertical) {
            
            // Header
            VStack{
                ZStack(alignment: .leading) {
                    cancelButton
                    Text("MiCaserito") // FIXME: should be spot's name
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .font(.system(size: 20))
                }.padding(.horizontal, 20)
                
                ScrollView(.vertical) {
                    
                    // Reviews
                    VStack {
                        ForEach(reviews, id: \.self) { review in
                            ZStack {
                                Rectangle()
                                    .fill(customGray)
                                    .cornerRadius(15)
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(review.title).bold()
                                        Spacer()
                                        Text("25s ago").foregroundColor(.gray) // FIXME: should calculate time
                                    }.padding()
                                    HStack {
                                        Spacer()
                                        Text(review.user)
                                            .foregroundColor(.gray)
                                    }.padding(.horizontal, 10)
                                    
                                    ZStack(alignment: .leading){
                                        Rectangle()
                                            .fill(Color.white)
                                            .cornerRadius(15)
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("Cleanliness")
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    ForEach(1..<6) { index in Image(systemName: "star.fill").foregroundColor(review.cleanliness >= index ? .yellow : .gray)}
                                                }
                                            }
                                            HStack {
                                                Text("Waiting time")
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    ForEach(1..<6) { index in Image(systemName: "star.fill").foregroundColor(review.waitingTime >= index ? .yellow : .gray)}
                                                }
                                            }
                                            HStack {
                                                Text("Service")
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    ForEach(1..<6) { index in Image(systemName: "star.fill").foregroundColor(review.service >= index ? .yellow : .gray)}
                                                }
                                            }
                                            HStack {
                                                Text("Food quality")
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    ForEach(1..<6) { index in Image(systemName: "star.fill").foregroundColor(review.foodQuality >= index ? .yellow : .gray)}
                                                }
                                            }
                                        }.padding()
                                    }.padding()
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(review.tags, id: \.self) { tag in
                                                Text(tag)
                                                    .font(.system(size: 16))
                                                    .bold()
                                                    .foregroundColor(.black)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 10)
                                                    .background(Color.white)
                                                    .cornerRadius(8)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    HStack {
                                        Text(review.description)
                                        if !review.photo.isEmpty {
                                            Spacer()
                                            Image(review.photo)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 70, height: 70)
                                                .cornerRadius(10)
                                        }
                                        
                                    }.padding()
                                }
                            }
                        }.padding(.vertical, 5)
                    }.padding()
                }
            }
        }
        
    }
    var cancelButton: some View {
        Button(action: {
            print("Redirecting to spot's detail...") // FIXME: Should actually redirect
        }) {
            Text("Cancel")
                .foregroundColor(.blue)
                .font(.system(size: 20))
        }
    }
    
    
    
}

#Preview {
    ReviewsView()
}
