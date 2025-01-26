//
//  HomeView.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var belongsToFamilyGroup: Bool = false
    @StateObject var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        _authViewModel = StateObject(wrappedValue: authViewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.primaryPurple.opacity(1.0)
                    .clipShape(CustomShape())
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 150)
                
                // Header
                HStack {
                    // Profile Image and Greeting
                    HStack {
                        AsyncImage(url: authViewModel.profileImageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primeryYellow.opacity(0.7), lineWidth: 3)
                                    )
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.7))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "person.circle.fill")
                                            .foregroundColor(.white)
                                    )
                            }
                        
                        VStack(alignment: .leading) {
                            Text("Morning!")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(authViewModel.userName)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Settings and Notifications
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image(systemName: "gear")
                                .foregroundColor(.white)
                        }
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, -40)
            }
            
            // Main Content: Conditional sections
            if belongsToFamilyGroup {
                VStack(spacing: 0) {
                    FeaturesSection()
                    // Scrollable Section
                    ScrollView {
                        VStack(spacing: 20) {
                            FamilySection()
                            ActivitySection()
                        }
                        .padding(.top)
                    }
                }
            } else {
                //Content for users without a family group
                VStack(spacing: 20) {
                    Spacer().frame(height: 20)
                    
                    Image("create_family")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .foregroundColor(.primary)
                    
                    Text("You are not part of a family group yet.")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(action: {
                        // Action to create or join a family group
                        print("Create Family Button Tapped")
                    }) {
                        Text("Create a Family")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.primaryPurple)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            Task{
                try? await authViewModel.getUserName()
                try? await authViewModel.getUserProfile()
            }
        }
    }
    
    struct CustomShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height - 60))
            
            // Create the curve
            path.addQuadCurve(
                to: CGPoint(x: rect.width, y: rect.height - 60),
                control: CGPoint(x: rect.width / 2, y: rect.height + 20)
            )
            
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.closeSubpath()
            
            return path
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}
