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
    @State private var draftMode = false
    @State private var loadingState = LoadingState.not_loading
    @State private var showNoConnectionAlert = false
    
    var spotId: String
    
    @ObservedObject var networkService = NetworkService.shared
    
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                    .padding(5)
                    if (loadingState != LoadingState.finished_loading) {
                        Text("Connect again to see this spot's detail")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            if loadingState == LoadingState.loading && networkService.isOnline {
                ProgressView("Loading spot's detail")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            else if (loadingState == LoadingState.finished_loading) {
                ZStack {
                    //customGray.edgesIgnoringSafeArea(.all)
                    ScrollView(.vertical) {
                        VStack {
                            
                            Map() {
                                Marker(model.spot.name, coordinate: CLLocationCoordinate2D(latitude: model.spot.location.latitude, longitude: model.spot.location.longitude))
                            }
                            .frame(width: 350, height: 200)
                            .padding(.horizontal)
                            .padding(.vertical)
                            
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
                                    if networkService.isOnline {
                                        let draftExists = DBManager().draftExists(spot: spotId)
                                        if (draftExists) {
                                            showDraftMenu.toggle()
                                        } else {
                                            draft = nil
                                            draftMode = false
                                            isNewReviewSheetPresented.toggle()
                                        }
                                    }
                                    else {
                                        showNoConnectionAlert.toggle()
                                    }
                                    
                                }, label: {
                                    Text("Leave a review")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .font(.system(size: 20))
                                }).padding().alert(isPresented: $showNoConnectionAlert) {
                                    Alert(title: Text("No connection"), message: Text("You can only leave reviews while being connected, please try again later!"), dismissButton: .default(Text("OK")))
                                }
                            }.actionSheet(isPresented: $showDraftMenu) {
                                ActionSheet(
                                    title: Text("It looks like you have a draft"),
                                    buttons: [
                                        .default(Text("Create review from draft")) {
                                            draft = DBManager().getDraft(spot: spotId)
                                            draftMode = true
                                            isNewReviewSheetPresented.toggle()
                                        },
                                        .default(Text("Create new review")) {
                                            draft = nil
                                            draftMode = false
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
            }
        }
        .background(loadingState == LoadingState.loading && networkService.isOnline ? nil : customGray)
        .onAppear {
            if networkService.isOnline {
                loadingState = LoadingState.loading
                fetchDataIfOnline()
            }
        }
        .onChange(of: networkService.isOnline) {
            if networkService.isOnline && loadingState != LoadingState.finished_loading {
                loadingState = LoadingState.loading
                fetchDataIfOnline()
            }
        }
        .navigationTitle(model.spot.name)
        .sheet(
            isPresented: $isReviewsSheetPresented,
            content: {
                ReviewsView(spotName: "MiCaserito", reviews: model.spot.reviewData.userReviews)
                    .presentationDragIndicator(.visible)
                    .padding(.top)
            })
        .sheet(
            isPresented: $isNewReviewSheetPresented,
            content: {
                CreateReview1View(spotId: spotId, spotName: model.spot.name, categories: model.categories, draft: draft, draftMode: draftMode, isNewReviewSheetPresented: $isNewReviewSheetPresented)
            })
    }
    func fetchDataIfOnline() {
        guard networkService.isOnline else { return }
        Task {
            do {
                let startTime = Date()
                try await model.fetchSpot(spotId: spotId)
                try await model.fetchCategories()
                loadingState = LoadingState.finished_loading
                let finishTime = Date()
                let time = (finishTime.timeIntervalSince(startTime) * 100).rounded() / 100
                model.addFetchingTime(spotId: spotId, spotName: model.spot.name, time: time)
            } catch {
                print("Error fetching data or uploading reviews: ", error.localizedDescription)
            }
        }
    }
}

enum LoadingState {
    case not_loading
    case loading
    case finished_loading
}


//#Preview {
//    SpotDetailView(spotId: "7kzd8gmyG842rx2Ad98b")
//}
