//
//  ReportReviewView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 5/11/24.
//

import SwiftUI

struct ReportReviewView: View {
    
    @State private var selection: ReportReason?
    @State private var model: ReviewReportViewModel = ReviewReportViewModel.shared
    @ObservedObject private var networkService = NetworkService.shared
    
    var reviewId: String
    
    var body: some View {
        
        List(ReportReason.allCases, id: \.self, selection: $selection) { reason in
            HStack {
                Text(reason.rawValue)
                Spacer()
                if reason.rawValue == selection?.rawValue {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.accentColor)
                        .bold()
                }
            }
        }
        .disabled(networkService.isUnavailable)
    
        VStack{
            if (networkService.isUnavailable) {
                Text("You seem to have lost connection, please make sure you are online to be able to send the report.")
                    .padding()
            }
            
            Button(action: {
                model.sendReport(reviewId: reviewId, reason: selection!)
            }, label: {
                Text("Leave a report")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selection == nil ? .gray : .blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.system(size: 20))
            })
            .padding()
            .disabled(selection == nil || networkService.isUnavailable)
        }
    }
}

#Preview {
    ReportReviewView(reviewId: "aaaaaaaaaaaa")
}
