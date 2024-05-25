//
//  ReviewCard.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 13/05/24.
//

import Foundation
import SwiftUI

struct ReviewCard: View {
    
    let review: Review
    let userId: String
    
    @ObservedObject var networkService = NetworkService.shared
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    
    var body: some View {
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
                        ForEach(review.selectedCategories.indices, id: \.self) { index in
                            let tag = review.selectedCategories[index]
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
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: ReportReviewView(reviewId: review.id ?? ""))
                    {
                        Label("Report", systemImage: "exclamationmark.circle")
                            .font(.caption)
                            .padding(10)
                            .foregroundStyle(review.user.id == userId ? .gray : .blue )
                    }.disabled(review.user.id == userId)
                }
            }
        }
    }
}
