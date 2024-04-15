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
    @State private var isReviewsSheetPresented : Bool = false
    @State private var isNewReviewSheetPresented : Bool = false
    @State private var showDraftMenu = false
    @State private var draft : ReviewDraft?
    
    var spotId: String
    
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
        
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                customGray.edgesIgnoringSafeArea(.all)
                ScrollView(.vertical) {
                    VStack {
                        Map() {
                            Marker(model.spot.name, coordinate: CLLocationCoordinate2D(latitude: model.spot.location.latitude, longitude: model.spot.location.longitude))
                        }
                        .frame(width: 350, height: 200)
                        .padding()
                        .cornerRadius(15)
                        
                        // Categories
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(Utils.shared.highestCategories(spot: model.spot), id: \.self) { cat in
                                    Text("\(cat.name.capitalized) (\(cat.count))")
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
                            Button(action: {
                                isReviewsSheetPresented.toggle()
                            }) {
                                Text("See more (\(model.spot.reviewData.userReviews.count))")
                                    .font(.system(size: 17))
                                    .foregroundColor(.blue)
                            }
                        }.padding(.horizontal, 20).padding(.vertical, 5)
                        
                        // Quality attributes
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(20)
                            VStack(spacing: 0) {
                                ForEach(model.ratings.keys.sorted(), id: \.self) { key in
                                    let rating = model.ratings[key] ?? 0
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
                            Button(action: {
                                let draftExists = DBManager().draftExists(spot: spotId)
                                if (draftExists) {
                                    showDraftMenu.toggle()
                                }
                                else {
                                    isNewReviewSheetPresented.toggle()
                                }
                                }, label: {
                                    Text("Leave a review")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .font(.system(size: 20))
                            }).padding()
                        }.actionSheet(isPresented: $showDraftMenu) {
                            ActionSheet(
                                title: Text("Looks like you have a draft"),
                                buttons: [
                                    .default(Text("Create review from draft")) {
                                        draft = DBManager().getDraft(spot: spotId)
                                        isNewReviewSheetPresented.toggle()
                                    },
                                    .default(Text("Create new review")) {
                                        draft = nil
                                        isNewReviewSheetPresented.toggle()
                                    },
                                    .cancel()
                                ]
                            )
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            
        }.task {
            _ = try? await model.fetchSpot(spotId: spotId)
        }
        .navigationTitle(model.spot.name)
        .sheet(
            isPresented: $isReviewsSheetPresented,
            content: {
                ReviewsView(spotName: "MiCaserito", reviews: model.spot.reviewData.userReviews)
            })
        .sheet(
            isPresented: $isNewReviewSheetPresented,
            content: {
                CreateReview1View(spotId: spotId, draft: draft, isNewReviewSheetPresented: $isNewReviewSheetPresented)
            })
    }
}

#Preview {
    SpotDetailView(spotId: "7kzd8gmyG842rx2Ad98b")
}
