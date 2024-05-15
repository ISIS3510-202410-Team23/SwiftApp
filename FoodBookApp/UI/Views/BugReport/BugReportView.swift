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
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Bug Details")) {
                    TextFieldWithLimit(textContent: $descriptionText, title: placeholderDescription, charLimit: 100)
                }
                Section(header: Text("Bug Type and Severity")) {
                    Picker("Bug Type", selection: $bugType) {
                        ForEach(["Unexpected Behavior", "Crash", "Other"], id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Severity Level", selection: $severityLevel) {
                        ForEach(["Minor", "Major"], id: \.self) {
                            Text($0)
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
                dismiss()
            }
        } message: {
            Text("Your report has been sent! We will review and take further action.")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save as draft") {
                    print("Hello world!") // TODO: add actual functionality
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
    }
}


#Preview {
    BugReportView()
}
