//
//  ReviewsView.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 27/02/24.
//

import Foundation
import SwiftUI


struct ReviewsView: View {
    @State private var model = ReviewsViewModel()
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let spotName : String
    
    var body: some View {
            
        // Header
        VStack(spacing: 0){
            ZStack(alignment: .leading) {
                TextButton(text: "Cancel", txtSize: 20, hPadding: 0)
                Text(spotName)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 20))
            }.padding()
            
            Separator()
            
            ScrollView(.vertical) {
                
                // Reviews
                VStack {
                    ForEach(model.reviews, id: \.self) { review in
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
                                
                                // Categories
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(review.tags, id: \.self) { tag in
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
                                    Text(review.description)
                                    if !review.photo.isEmpty {
                                        Spacer()
                                        AsyncImage(url: URL(string: review.photo)) { image in
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
                .task {
                    _ = try? await model.fetchReviews()
                }
            }
        }
        
    }
}

#Preview {
    ReviewsView(spotName: "MiCaserito")
}
