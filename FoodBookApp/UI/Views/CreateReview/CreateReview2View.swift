//
//  CreateReview2View.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct CreateReview2View: View {
    let categories: [String]
    @State private var selectedImage: UIImage?
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var addPhotoText: String = "Add a photo..."
    @State private var cleanliness: Int = 0
    @State private var waitingTime: Int = 0
    @State private var service: Int = 0
    @State private var foodQuality: Int = 0
    @State private var reviewTitle: String = ""
    @FocusState private var reviewTitleIsFocused: Bool
    @State private var reviewBody: String = ""
    @FocusState private var reviewBodyIsFocused: Bool
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let customGray2 = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack{
                TextButton(text: "Cancel", txtSize: 20, hPadding: 0) // FIXME: should redirect
                Spacer()
                Text("Review")
                    .bold()
                    .font(.system(size: 20))
                Spacer()
                BoldTextButton(text: "Done", txtSize: 20) { print("Done") } // FIXME: should verify inputs and send them to DB
                
            }.padding(.horizontal).padding(.top)
            
            Separator()
            
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
                
                // Photo
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .padding()
                        .cornerRadius(10)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(customGray)
                        .frame(height: 150)
                        .padding()
                }
                
                // Add photo button
                addPhotoButton
                
                VStack(alignment: .leading) {
                    Text("Leave a comment").bold().font(.system(size: 25)).padding()
                    
                    // Review title
                    HStack {
                        Text("Title").font(.system(size: 20))
                        TextField("Optional", text: $reviewTitle)
                            .focused($reviewTitleIsFocused)
                            .padding(.leading)
                        Spacer()
                        if reviewTitleIsFocused {
                            ClearButton(){
                                reviewTitle = ""
                                reviewTitleIsFocused = false}
                        }
                    }.padding(.horizontal)
                    
                    Separator().padding(.horizontal)
                    
                    // Review body
                    HStack {
                        Text("Body").font(.system(size: 20))
                        TextField("Value", text: $reviewBody)
                            .focused($reviewBodyIsFocused)
                            .padding(.leading)
                        Spacer()
                        if reviewBodyIsFocused {
                            ClearButton(){
                                reviewBody = ""
                                reviewBodyIsFocused = false}
                        }
                    }.padding(.horizontal)
                }.padding(.horizontal, 15)
                
                Spacer()
            }
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$selectedImage, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }.onChange(of: selectedImage) {
            Task {
                addPhotoText = "Change photo"
            }
        }
    }
    
    var addPhotoButton: some View { // FIXME: should be component (?)
        
        Button(action : {
            self.showSheet = true
        }) {
            Text(addPhotoText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(customGray)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .font(.system(size: 20))
        }.actionSheet(isPresented: $showSheet) {
            ActionSheet(title: Text("Select an option"), buttons: [
                .default(Text("Photo Library")) {
                    self.showImagePicker = true
                    self.sourceType = .photoLibrary
                },
                .default(Text("Camera")) {
                    self.showImagePicker = true
                    self.sourceType = .camera
                },
                .cancel()
            ])
        }
        
    }
    
}

#Preview {
    CreateReview2View(categories: ["Homemade", "Colombian"])
}
