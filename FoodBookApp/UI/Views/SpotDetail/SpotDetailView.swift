//
//  SpotDetailView.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 26/02/24.
//

import Foundation
import SwiftUI
import MapKit

struct SpotDetailView: View {
    @State private var model = SpotDetailViewModel()
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let ratings: [String: Double] = ["Cleanliness": 0.81, "Waiting time": 0.99, "Service": 0.36, "Food quality": 0.73] // FIXME: should calculate or retrieve stats
        
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                // < Browse
               HStack {
                   BackChevron(text: "Browse")
               }.padding(.vertical, 1)
                   
                // Spot name
                HStack() {
                    Text(model.spot.name)
                       .font(.system(size: 30))
                       .bold()
               }
            }.padding(.horizontal, 20)
            
            ZStack {
                customGray.edgesIgnoringSafeArea(.all)
                ScrollView(.vertical) {
                    VStack {
                        
                        Map() {
                            Marker(model.spot.name, coordinate: CLLocationCoordinate2D(latitude: model.spot.latitude, longitude: model.spot.longitude))
                        }.frame(width: 350, height: 200).padding()
                        
                        // Categories
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(model.spot.categories, id: \.self) { cat in
                                    Text(cat)
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
                        
                        // Reviews - See more
                        HStack {
                            Text("Reviews")
                                .font(.system(size: 24))
                                .bold()
                                .frame(alignment: .leading)
                            Spacer()
                            TextButton(text: "See more", txtSize: 17, hPadding: 5)
                        }.padding(.horizontal, 20).padding(.vertical, 5)
                        
                        // Quality attributes
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(20)
                            VStack(spacing: 0) {
                                ForEach(ratings.keys.sorted(), id: \.self) { key in
                                    let rating = ratings[key] ?? 0
                                    HStack(spacing: 0) {
                                        VStack(alignment: .leading) {
                                            Text(key).font(.system(size: 18))
                                            HStack {
                                                Image(systemName: rating >= 0.5 ? "hand.thumbsup" : "hand.thumbsdown")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.gray)
                                                Text(String(format: "%.0f%%", rating * 100)).bold().foregroundColor(.gray).font(.system(size: 15))
                                            
                                            }
                                        }.frame(maxWidth: 200, alignment: .leading)
                                            .padding(.horizontal, 15)
                                        
                    
                                        ZStack {
                                            GeometryReader { geometry in
                                                Rectangle()
                                                    .fill(customGray)
                                                    .frame(width: geometry.size.width, height: 5)
                                                    .cornerRadius(5)
                                            }
                                            
                                            GeometryReader { geometry in
                                                Rectangle()
                                                    .fill(Color.blue)
                                                    .frame(width: CGFloat(rating) * geometry.size.width, height: 5)
                                                    .cornerRadius(5)
                                            }
                                        }.padding()
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .cornerRadius(12)
 
                        // Leave a review
                        HStack {
                            LargeButton(text: "Leave a review", bgColor: Color.blue, txtColor: Color.white, txtSize: 20)
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            
        }.task {
            _ = try? await model.fetchSpot()
        }
    }

}

#Preview {
    SpotDetailView()
}
