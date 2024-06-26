//
//  CreateReview1View.swift
//  FoodBookApp
//
//  Created by Laura Restrepo on 28/02/24.
//

import Foundation
import SwiftUI

struct CreateReview1View: View {
    var spotId: String
    var spotName: String
    var categories: [String]
    var draft: ReviewDraft?
    var draftMode: Bool
    @State private var model = CreateReview1ViewModel()
    @State private var searchText: String = ""
    @FocusState private var searchTextIsFocused: Bool
    @State private var selectedCats: [String] = []
    @Binding var isNewReviewSheetPresented: Bool
    @State private var showAlert = false
    @State private var showDraftAlert = false
    @State private var cleanliness = 0
    @State private var waitingTime = 0
    @State private var foodQuality = 0
    @State private var service = 0
    @State private var selectedImage: UIImage?
    @State private var title = ""
    @State private var content = ""
    @State private var imageChange = false
    @State private var shouldCount = true
    private let utils = Utils.shared
    
    let customGray = Color(red: 242/255, green: 242/255, blue: 242/255)
    let customGray2 = Color(red: 242/255, green: 242/255, blue: 247/255)
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading){
                    // Header
                    HStack{
                        TextButton(text: "Cancel", txtSize: 17, hPadding: 0, action: {
                            // Review is not empty
                            if (!selectedCats.isEmpty || cleanliness > 0 || waitingTime > 0 || foodQuality > 0 || service > 0 || !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedImage != nil) {
                                
                                let filteredCats = draft?.selectedCategories.filter { !$0.isEmpty }
                                
                                // Draft is different
                                if (filteredCats != selectedCats || draft?.ratings.cleanliness != cleanliness || draft?.ratings.foodQuality != foodQuality || draft?.ratings.waitTime != waitingTime
                                    || draft?.ratings.service != service || ((draftMode && imageChange) || (!draftMode && selectedImage != nil)) || draft?.title != title || draft?.content != content) {
                                    showDraftAlert.toggle()
                                }
                                else {
                                    isNewReviewSheetPresented.toggle()
                                }
                            }
                            else {
                                isNewReviewSheetPresented.toggle()
                            }
                        })
                        .alert(isPresented: $showDraftAlert) {
                            Alert(
                                title: Text("Would you like to save this review as a draft?"),
                                message: Text("This will delete your latest draft"),
                                primaryButton: .default(Text("No")) {
                                    isNewReviewSheetPresented.toggle()
                                    shouldCount = true
                                },
                                secondaryButton: .default(Text("Yes")) {
                                    if (DBManager().draftExists(spot: spotId)) {
                                        DBManager().deleteDraft(spot: spotId)
                                    }
                                    shouldCount = false
                                    let imageName = "\(UUID().uuidString).jpg"
                                    
                                    DBManager().addDraft(spotValue: spotId, cat1Value: selectedCats.indices.contains(0) ? selectedCats[0] : "", cat2Value: selectedCats.indices.contains(1) ? selectedCats[1] : "", cat3Value: selectedCats.indices.contains(2) ? selectedCats[2] : "", cleanlinessValue: cleanliness, waitTimeValue: waitingTime, foodQualityValue: foodQuality, serviceValue: service, imageValue: selectedImage != nil ? imageName : "", titleValue: title, contentValue: content)
                                    
                                    isNewReviewSheetPresented.toggle()
                                    
                                    if selectedImage != nil {
                                        utils.saveLocalImage(image: selectedImage, imageName: imageName)
                                    }
                                    else {
                                        DBManager().deleteDraftImage(spot: spotId)
                                    }
                                }
                            )
                        }
                        Spacer()
                        Text("Review")
                            .bold()
                        Spacer()
                        if selectedCats.isEmpty {
                            Button("Next") {
                                showAlert.toggle()
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Try again"), message: Text("Please select at least one category"), dismissButton: .default(Text("OK")))
                            }
                        } else {
                            NavigationLink(destination: CreateReview2View(categories: self.selectedCats, spotId: spotId, draftMode: draftMode, shouldCount: $shouldCount, imageChange: $imageChange, selectedImage: $selectedImage, cleanliness: $cleanliness, waitingTime: $waitingTime, foodQuality: $foodQuality, service: $service, title: $title, content: $content, isNewReviewSheetPresented: $isNewReviewSheetPresented)) {
                                Text("Next")
                            }
                        }
                        
                    }.padding(.horizontal).padding(.top)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("What did you order?")
                            .font(.system(size: 24))
                            .bold()
                        Text("Select at least one and up to three categories").foregroundColor(.gray).padding(.top, 5)
                        
                        // Search bar
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(customGray)
                                .frame(height: 40)
                                .padding(.top, 20)
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.top, 20)
                                    .padding(.leading, 10)
                                TextField("Search", text: $searchText)
                                    .padding(.vertical, 10)
                                    .cornerRadius(8)
                                    .focused($searchTextIsFocused)
                                    .padding(.top, 20)
                                if searchTextIsFocused {
                                    ClearButton(){
                                        searchText = ""
                                    }.padding(.top, 20).padding(.trailing, 10)
                                }
                            }.toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Spacer()
                                        Button("OK") {
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 20).padding(.top)
                    
                    // Categories
                    ScrollView() {
                        VStack(alignment: .leading, spacing: 0) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading) {
                                ForEach(searchResults.indices, id: \.self) { index in
                                    let cat = searchResults[index]
                                    Button(action: {
                                        if selectedCats.contains(cat) {
                                            selectedCats.removeAll { $0 == cat }
                                        }
                                        else {
                                            if selectedCats.count < 3 {
                                                selectedCats.append(cat)
                                            }
                                        }
                                        
                                    }, label: {Text(cat.capitalized)
                                            .font(.system(size: 14))
                                            .bold()
                                            .foregroundColor(selectedCats.contains(cat) ? Color.white : Color.black)
                                            .padding(10)
                                            .background(selectedCats.contains(cat) ? Color.black : customGray)
                                        .cornerRadius(8)})
                                }.padding(.bottom, 5)
                            }.padding(.top, 20)
                        }.padding(.horizontal, 20)
                        
                        Spacer()
                    }
                    
                }
            }
        }
        .onAppear {
            if let draft = draft {
                selectedCats = draft.selectedCategories.filter { !$0.isEmpty }
                cleanliness = draft.ratings.cleanliness
                waitingTime = draft.ratings.waitTime
                foodQuality = draft.ratings.foodQuality
                service = draft.ratings.service
                if (draft.image != "") {
                    let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(draft.image)
                    selectedImage = UIImage(contentsOfFile: imagePath.path)
                }
                title = draft.title
                content = draft.content
            }
            else {
                selectedCats = []
                cleanliness = 0
                waitingTime = 0
                foodQuality = 0
                service = 0
                selectedImage = nil
                title = ""
                content = ""
            }
        }.onDisappear {
            let filteredCats = draft?.selectedCategories.filter { !$0.isEmpty }
            if (shouldCount && ((!draftMode && (!selectedCats.isEmpty || cleanliness > 0 || waitingTime > 0 || foodQuality > 0 || service > 0 || !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedImage != nil)) || (draftMode && (filteredCats != selectedCats || draft?.ratings.cleanliness != cleanliness || draft?.ratings.foodQuality != foodQuality || draft?.ratings.waitTime != waitingTime || draft?.ratings.service != service || imageChange || draft?.title != title || draft?.content != content)))) {
                Task {
                    do {
                        try await model.increaseUnfinishedReviewCount(spotId: spotId, spotName: spotName)
                    } catch {
                        print("Error increasing unfinished review count: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter { cat in
                cat.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

#Preview {
    CreateReview1View(spotId: "ms1hTTxzVkiJElZiYHAT", spotName: "Mi Caserito", categories: ["Homemade", "Colombian"], draftMode: false, isNewReviewSheetPresented: .constant(true))
}
