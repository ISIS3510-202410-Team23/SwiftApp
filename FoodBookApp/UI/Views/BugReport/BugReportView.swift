//
//  BugReportView.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 11/05/24.
//

import SwiftUI

struct BugReportView: View {
    @State private var title = ""
    @State private var descriptionText = ""
    @State private var placeholderDescription = "Describe the issue..."
    @State private var bugType = "Unexpected Behavior"
    @State private var severityLevel = "Minor"
    @State private var stepsToReproduce = ""
    @State private var placeholderStepsToReproduce = "Enter steps to reproduce the bug..."

    var body: some View {
            Form {
                Section(header: Text("Bug Details")) {
//                    TextEditorWithPlaceholder(text: $descriptionText, placeholder: $placeholderDescription)
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
//                    TextEditorWithPlaceholder(text: $stepsToReproduce, placeholder: $placeholderStepsToReproduce)
                }
                
            }
            
            LargeButton(text: "Send bug report", bgColor: Color.blue, txtColor: Color.white, txtSize: 20)
            {
                print("Hello world!") // TODO: Should send
            }
    }
}

    
#Preview {
    BugReportView()
}
