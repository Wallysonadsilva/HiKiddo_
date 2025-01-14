//
//  HomeView.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    // Profile Image and Greeting
                    HStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("Morning!")
                                .font(.headline)
                            Text("Catarina")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Settings and Notifications
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image(systemName: "gear")
                                .foregroundColor(.gray)
                        }
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                // Main content sections
                FeaturesSection()
                FamilySection()
                ActivitySection()
            }
        }
    }
}

#Preview {
    HomeView()
}
