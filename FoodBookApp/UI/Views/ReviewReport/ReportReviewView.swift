//
//  ReportReviewView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 5/11/24.
//

import SwiftUI
import Combine

struct ReportReviewView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var selection: ReportReason?
    @State private var explanation: String = ""
    @FocusState private var focus: Bool
    @State private var sent: Bool = false
    @State private var model: ReviewReportViewModel = ReviewReportViewModel.shared
    @ObservedObject private var networkService = NetworkService.shared
    
    var reviewId: String
    
    var body: some View {
        
        VStack (spacing: 0) {
            // MARK: - List of reasons
            List(ReportReason.allCases, id: \.self, selection: $selection) { reason in
                HStack {
                    Text(reason.rawValue)
                    Spacer()
                    if reason == selection {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color.accentColor)
                            .bold()
                    }
                }
                .onChange(of: selection) {
                    if selection != .other {
                        explanation = ""
                    }
                }
            }
            
            // MARK: - Optional text section
            if selection == .other  {
                TextFieldWithLimit(textContent: $explanation, title: "Please explain why you selected 'Other'", charLimit: 180)
                    .padding()
                    .focused($focus)
                    .toolbar { // adding the toolbar
                                        ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("Done") {
                                                    focus = false
                                                }
                                        }
                                    }
            }
            
            
            // MARK: - Button to send
            Button(action: {
                model.sendReport(reviewId: reviewId, reason: selection == .other ? explanation.trimmingCharacters(in: .whitespacesAndNewlines) : selection!.rawValue)
                sent = true
            }, label: {
                Text("Leave a report")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selection == nil || networkService.isUnavailable || explanation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.system(size: 20))
            })
            .padding()
            .disabled(selection == nil || networkService.isUnavailable || explanation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            // MARK: - EC Message
            
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
        .navigationTitle("Review Report")
        .alert("Thank you for making foodbook better!", isPresented: $sent) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Your report has been sent! We will review and take further action if needed.")
        }
        
        
    }
}

#Preview {
    ReportReviewView(reviewId: "aaaaaaaaaaaa")
}
