//
//  BugReportView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 11/05/24.
//s

import SwiftUI

struct BugReportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var descriptionText = ""
    @State private var placeholderDescription = "[REQUIRED]: Describe the issue..."
    @State private var bugType = "Unexpected Behavior"
    @State private var severityLevel = "Minor"
    @State private var stepsToReproduce = ""
    @State private var placeholderStepsToReproduce = "For example: Open the app > navigate to the ForYou page > tap on the logout button"
    @State private var sent: Bool = false
    @ObservedObject private var networkService = NetworkService.shared
    
    @State private var model = BugReportViewModel.shared
    
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert? = nil
    @State private var draftMode = false
    
    @State private var bugTypeList = ["Unexpected Behavior", "Crash", "Other"];
    @State private var severityLevelList = ["Major", "Minor"];
    
    var body: some View {
        VStack {
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
                    .padding(4)
                }
            }
            Form {
                Section(header: Text("Bug Details")) {
                    TextFieldWithLimit(textContent: $descriptionText, title: placeholderDescription, charLimit: 100)
                }
                Section(header: Text("Bug Type and Severity")) {
                    Picker("Bug Type", selection: $bugType) {
                        ForEach(bugTypeList.indices, id: \.self) { index in
                            let bugTypeElement = bugTypeList[index];
                            Text(bugTypeElement);
                        }
                    }
                    Picker("Severity Level", selection: $severityLevel) {
                        ForEach(severityLevelList.indices, id: \.self) { index in
                            let severityLevelElement = severityLevelList[index];
                            Text(severityLevelElement)
                        }
                    }
                }
                Section(header: Text("Steps to Reproduce")) {
                    TextFieldWithLimit(textContent: $stepsToReproduce, title: placeholderStepsToReproduce, charLimit: 100)
                }
                
                Section {
                    LargeButton(text: "Send bug report", bgColor: networkService.isUnavailable || descriptionText.isEmpty ? Color.gray : Color.blue, txtColor: Color.white, txtSize: 20) {
                        model.send(date: Date(), description: self.descriptionText, bugType: self.bugType, severityLevel: self.severityLevel, stepsToReproduce: self.stepsToReproduce)
                        sent = true
                    }
                    .disabled(networkService.isUnavailable || descriptionText.trimmingCharacters(in: .whitespaces).isEmpty)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    
                    if(networkService.isUnavailable) {
                        HStack {
                            Spacer()
                            Text("No connection, please make sure you have internet access before attempting to send")
                                .foregroundStyle(.red)
                                .disabled(networkService.isUnavailable)
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .disabled(networkService.isUnavailable)
            }
        }
        .navigationTitle("Report a bug")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you for making FoodBook better!", isPresented: $sent) {
            Button("OK", role: .cancel) {
                if DBManager().bugReportDraftExists() && draftMode {
                    DBManager().deleteBugReportDraft()
                }
                dismiss()
            }
        } message: {
            Text("Your report has been sent! We will review and take further action.")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save as draft") {
                    activeAlert = .saveDraft
                    showAlert = true
                }
            }
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("OK") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
        }
        .onAppear {
            if DBManager().bugReportDraftExists() {
                activeAlert = .loadDraft
                showAlert = true
            }
        }.alert(isPresented: $showAlert) {
            if activeAlert == .loadDraft {
                return Alert(
                    title: Text("It looks like you have a draft"),
                    message: Text("Would you like to load it?"),
                    primaryButton: .default(Text("No")) {
                        showAlert = false
                    },
                    secondaryButton: .default(Text("Yes")) {
                        let draft = DBManager().getBugreportDraft()
                        if let draft = draft {
                            descriptionText = draft.details
                            bugType = draft.type
                            severityLevel = draft.severity
                            stepsToReproduce = draft.steps
                        }
                        draftMode = true
                    }
                )
            }
            else  { // saveDraft
                return Alert(
                    title: Text("Would you like to save this bug report as a draft?"),
                    message: Text("This will delete your latest draft"),
                    primaryButton: .default(Text("No")) {
                        showAlert = false
                    },
                    secondaryButton: .default(Text("Yes")) {
                        if (DBManager().bugReportDraftExists()) {
                            DBManager().deleteBugReportDraft()
                        }
                        DBManager().addBugReportDraft(detailsValue: descriptionText, typeValue: bugType, severityValue: severityLevel, stepsValue: stepsToReproduce)
                    }
                )
            }
        }
    }
}

enum ActiveAlert {
    case saveDraft, loadDraft
}


#Preview {
    BugReportView()
}
