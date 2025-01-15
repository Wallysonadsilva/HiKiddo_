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
        
        VStack() {
            ZStack{
                Color.primaryPurple.opacity(1.0)
                    .clipShape(CustomShape())
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 150)
                
                // Header
                HStack {
                    // Profile Image and Greeting
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.7))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("Morning!")
                                .font(.headline)
                                .foregroundColor(.white)
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
            // Main content sections
            FeaturesSection()
            ScrollView {
                FamilySection()
                ActivitySection()
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
    HomeView()
}
