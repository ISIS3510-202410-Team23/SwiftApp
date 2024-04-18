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
    let spotId: String
    var draftMode: Bool
    @Binding var shouldCount: Bool
    @Binding var imageChange: Bool
    @Binding var selectedImage: UIImage?
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var cleanliness: Int
    @Binding var waitingTime: Int
    @Binding var foodQuality: Int
    @Binding var service: Int
    @Binding var title: String
    @Binding var content: String
    @FocusState private var titleIsFocused: Bool
    @FocusState private var contentIsFocused: Bool
    @Binding var isNewReviewSheetPresented: Bool
    @State private var showAlert = false
    
    let notify = NotificationHandler()
    @State private var model = CreateReview2ViewModel()
    
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let customGray2 = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            
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
                    .navigationTitle("Review")
                    .toolbar{
                        Button(action: {
                            
                            if cleanliness == 0 || waitingTime == 0 || service == 0 || foodQuality == 0 {
                                showAlert.toggle()
                            }
                            else {
                                shouldCount = false
                                // Step 1: Upload review
                                let reviewDate = Date()
                                let lowercasedCategories = categories.map { $0.lowercased() }
                                
                                Task {
                                    do {
                                        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                                        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                                        let reviewImage = try await model.uploadPhoto(image: selectedImage)
                                        let newReview = Review(content: trimmedContent == "" ? nil : trimmedContent,
                                                               date: reviewDate,
                                                               imageUrl: reviewImage,
                                                               ratings: ReviewStats(
                                                                cleanliness: cleanliness,
                                                                foodQuality: foodQuality,
                                                                service: service,
                                                                waitTime: waitingTime),
                                                               selectedCategories: lowercasedCategories,
                                                               title: trimmedTitle == "" ? nil : trimmedTitle,
                                                               user: UserInfo(id: model.username, name: model.user) )
                                        do {
                                            let reviewId = try await model.addReview(review: newReview)
                                            try await model.addReviewToSpot(spotId: spotId, reviewId: reviewId)
                                            if (DBManager().draftExists(spot: spotId) && draftMode) {
                                                DBManager().deleteImage(spot: spotId)
                                                DBManager().deleteDraft(spot: spotId)
                                            }
                                            print("The review uploaded has this ID:", reviewId)
                                            
                                        } catch {
                                            print("Error adding review: \(error)")
                                        }
                                    }
                                    catch {
                                        print(error)
                                    }
                                }
                                
                                // Very Nice To Have, but that the "Done" turns into the loading indicator while the review is uploaded, idk how complex it could be though.
                                
                                // Step 1.5: Trigger notification
                                notify.sendLastReviewNotification(date: reviewDate)
                                
                                // Step 2: Close sheet
                                isNewReviewSheetPresented.toggle()
                            }
                            
                        }, label: {
                            Text("Done")
                                .frame(maxWidth: .infinity)
                        })
                    }
                
                // Photo
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .padding(.top)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(customGray)
                        .frame(height: 150)
                        .padding(.horizontal).padding(.top)
                }
                
                // Add or remove photo button
                if selectedImage == nil {
                    addPhotoButton.padding()
                }
                else {
                    LargeButton(text: "Remove photo", bgColor: customGray, txtColor: Color.red, txtSize: 20){ selectedImage = nil }
                }
                
                // Leave a comment
                VStack(alignment: .leading) {
                    Text("Leave a comment").bold().font(.system(size: 25))
                        .padding(.horizontal).padding(.bottom)
                    
                    // Review title
                    HStack {
                        Text("Title").font(.system(size: 20))
                        TextField("Optional", text: $title)
                            .focused($titleIsFocused)
                            .padding(.leading)
                        Spacer()
                        if titleIsFocused {
                            ClearButton(){
                                title = ""
                                titleIsFocused = false}
                        }
                    }.padding(.horizontal)
                    
                    Separator().padding(.horizontal)
                    
                    // Review body
                    HStack {
                        Text("Body").font(.system(size: 20))
                        TextField("Value", text: $content)
                            .focused($contentIsFocused)
                            .padding(.leading)
                        Spacer()
                        if contentIsFocused {
                            ClearButton(){
                                content = ""
                                contentIsFocused = false}
                        }
                    }.padding(.horizontal)
                }.padding(.horizontal, 15)
                
                Spacer()
            }
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$selectedImage, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }.onChange(of: selectedImage) {
            Task {
                if (draftMode) {
                    imageChange = true
                }
            }
        }.alert("Try again", isPresented: $showAlert) {
            
        } message: {
            Text("Please make sure to at least fill out all the star ratings")
        }.task {
            _ = try? await model.getUserInfo()
        }
    }
    
    var addPhotoButton: some View {
        
        Button(action : {
            self.showSheet = true
        }) {
            Text("Add a photo..")
                .frame(maxWidth: .infinity)
                .padding()
                .background(customGray)
                .cornerRadius(12)
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
    CreateReview2View(categories: ["Homemade", "Colombian"], spotId: "ms1hTTxzVkiJElZiYHAT", draftMode: false, shouldCount: .constant(false), imageChange: .constant(false), selectedImage: .constant(nil), cleanliness: .constant(0), waitingTime: .constant(0), foodQuality: .constant(0), service: .constant(0), title: .constant(""), content: .constant(""), isNewReviewSheetPresented: .constant(true))
}
