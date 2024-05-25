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
    @State private var showFillStarsAlert = false
    @State private var showUploadLaterAlert = false
    
    @ObservedObject var networkService = NetworkService.shared
    private let utils = Utils.shared
    
    let notify = NotificationHandler()
    @State private var model = CreateReview2ViewModel()
    
    @State private var doneTapped = false;
    
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let customGray2 = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    let authBeforeReviews = UserDefaults.standard.bool (forKey: "authenticateBeforeUploading")
    
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
                                showFillStarsAlert.toggle()
                            }
                            else {
                                doneTapped = true;
                                let reviewDate = Date()
                                let lowercasedCategories = categories.map { $0.lowercased() }
                                let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                                let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                                shouldCount = false
                                
                                if !authBeforeReviews {
                                    onUpload(trimmedContent: trimmedContent, reviewDate: reviewDate, lowercasedCategories: lowercasedCategories, trimmedTitle: trimmedTitle)
                                } else {
                                    AuthService.shared.authenticateUser { success in
                                        if success {
                                            onUpload(trimmedContent: trimmedContent, reviewDate: reviewDate, lowercasedCategories: lowercasedCategories, trimmedTitle: trimmedTitle)
                                        } else {
                                            print("Could not authenticate")
                                        }
                                    }
                                }
                                
                                notify.sendLastReviewNotification(date: reviewDate)
                                
                                if (DBManager().draftExists(spot: spotId) && draftMode) {
                                    DBManager().deleteDraftImage(spot: spotId)
                                    DBManager().deleteDraft(spot: spotId)
                                }
                            }
                            
                        }, label: {
                            Text("Done")
                                .frame(maxWidth: .infinity)
                        }).disabled(doneTapped)
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
                            }
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
                            }
                        }
                    }.padding(.horizontal)
                }.padding(.horizontal, 15)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Button(action: {
                                    if !titleIsFocused {
                                        titleIsFocused = true
                                    }
                                }) {
                                    Image(systemName: "chevron.up")
                                        .foregroundColor(titleIsFocused ? .secondary : .blue)
                                }.disabled(titleIsFocused)
                                Button(action: {
                                    if !contentIsFocused {
                                        contentIsFocused = true
                                    }
                                }) {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(contentIsFocused ? .secondary : .blue)
                                }.disabled(contentIsFocused)
                                Spacer()
                                Button("OK") {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                        }
                    }
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
        }.alert("Try again", isPresented: $showFillStarsAlert) {
            
        } message: {
            Text("Please make sure to at least fill out all the star ratings")
        }.alert("No connection", isPresented: $showUploadLaterAlert) {
        } message: {
            Text("We couldn't upload your review, but don't worry, we'll do it once you have connection")
        }
        .onChange(of: showUploadLaterAlert) {
            if !showUploadLaterAlert {
                isNewReviewSheetPresented.toggle()
            }
        }
        .task {
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
    
    func onUpload(trimmedContent: String, reviewDate: Date, lowercasedCategories: [String], trimmedTitle: String) {
        if networkService.isOnline {
            // Step 1: Upload review
            Task {
                do {
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
                        
                        print("The review uploaded has this ID:", reviewId)
                        
                    } catch {
                        print("Error adding review: \(error)")
                    }
                }
                catch {
                    print(error)
                }
            }
                        
            // Step 2: Close sheet
            isNewReviewSheetPresented.toggle()
        } else {
            let imageName = "\(UUID().uuidString).jpg"
            let idValue = UUID().uuidString
            DBManager().addUpload(idValue: idValue, spotValue: spotId, cat1Value: lowercasedCategories.indices.contains(0) ? lowercasedCategories[0] : "", cat2Value: lowercasedCategories.indices.contains(1) ? lowercasedCategories[1] : "", cat3Value: lowercasedCategories.indices.contains(2) ? lowercasedCategories[2] : "", cleanlinessValue: cleanliness, waitTimeValue: waitingTime, foodQualityValue: foodQuality, serviceValue: service, imageValue: selectedImage != nil ? imageName : "", titleValue: trimmedTitle, contentValue: trimmedContent, dateValue: reviewDate)
            if selectedImage != nil {
                utils.saveLocalImage(image: selectedImage, imageName: imageName)
            }
            showUploadLaterAlert.toggle()
        }
    }
}

//#Preview {
//    CreateReview2View(categories: ["Homemade", "Colombian"], spotId: "ms1hTTxzVkiJElZiYHAT", draftMode: false, shouldCount: .constant(false), imageChange: .constant(false), selectedImage: .constant(nil), cleanliness: .constant(0), waitingTime: .constant(0), foodQuality: .constant(0), service: .constant(0), title: .constant(""), content: .constant(""), isNewReviewSheetPresented: .constant(true))
//}
