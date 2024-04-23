//
//  RootView.swift
//  FoodBookApp
//
//  Created by Maria Castro on 2/27/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    @State private var inputHistory: [String] = []
    
    private let fileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("inputHistory.json")
    }()
    
    var body: some View {
        ZStack {
            if !showSignInView {
                ContentView(showSignInView: $showSignInView, inputHistory: $inputHistory)
            }
        }
        .onAppear {
            loadInputHistory()
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                LoginView(showSignInView: $showSignInView)
            }
        }
    }
    
    private func loadInputHistory() {
        if let data = try? Data(contentsOf: fileURL),
           let history = try? JSONDecoder().decode([String].self, from: data) {
            inputHistory = history
        }
    }
}

#Preview {
    RootView()
}
