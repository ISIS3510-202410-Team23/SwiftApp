//
//  CreateReview2View.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import SwiftUI
import UIKit

struct CreateReview2View: View {
    @State private var selectedImage: Image?
    @State private var showPhotoPicker = false
    @State private var cleanliness: Int = 0
    @State private var waitingTime: Int = 0
    @State private var service: Int = 0
    @State private var foodQuality: Int = 0
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let customGray2 = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack{
                cancelButton
                Spacer()
                Text("Review")
                    .bold()
                    .font(.system(size: 20))
                Spacer()
                doneButton
                
            }.padding()
            
            // Separator
            Rectangle()
                .fill(.gray).frame(height: 0.5)
            
            ScrollView(.vertical) {
                // Quality attributes
                ZStack(){
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Cleanliness")
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(1..<6) { index in
                                    Button(action: {
                                        cleanliness = index
                                    }) {
                                        Image(systemName: cleanliness < index ? "star" : "star.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }.padding(.bottom, 5)
                        HStack {
                            Text("Waiting time")
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(1..<6) { index in
                                    Button(action: {
                                        waitingTime = index
                                    }) {
                                        Image(systemName: waitingTime < index ? "star" : "star.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }.padding(.bottom, 5)
                        HStack {
                            Text("Service")
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(1..<6) { index in
                                    Button(action: {
                                        service = index
                                    }) {
                                        Image(systemName: service < index ? "star" : "star.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }.padding(.bottom, 5)
                        HStack {
                            Text("Food quality")
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(1..<6) { index in
                                    Button(action: {
                                        foodQuality = index
                                    }) {
                                        Image(systemName: foodQuality < index ? "star" : "star.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }.padding().background(customGray2).cornerRadius(10)
                }.padding(.horizontal).padding(.top)
                
                // TODO: photo
                if let image = selectedImage {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: .infinity, height: 150)
                                    .padding()
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(customGray)
                                    .frame(width: .infinity, height: 150)
                                    .padding()
                }
                
                // Add photo button
                addPhotoButton
                
                VStack(alignment: .leading) {
                    Text("Leave a comment").bold().font(.system(size: 25)).padding()
                    
                    // Review title
                    HStack {
                        Text("Title").font(.system(size: 20))
                        // TODO: text input
                    }.padding(.horizontal)
                    
                    // Separator
                    Rectangle()
                        .fill(.gray).frame(height: 0.5).padding(.horizontal)
                    
                    // Review body
                    HStack {
                        Text("Body").font(.system(size: 20))
                        // TODO: text input
                    }.padding(.horizontal)
                }.padding(.horizontal, 15)

                Spacer()
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
    
    var doneButton: some View {
        Button(action: {
            print("Redirecting to reviews...") // FIXME: Should actually redirect
        }) {
            Text("Done")
                .foregroundColor(.blue)
                .font(.system(size: 20))
                .bold()
        }
    }
    
    var addPhotoButton: some View {
        Button(action: {
            showPhotoPicker.toggle()
            }, label: {
                Text("Add a photo...")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(customGray)
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                    .font(.system(size: 20))
        }).padding(.horizontal)
    }
}

#Preview {
    CreateReview2View()
}

