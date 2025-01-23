//
//  ActivityCardView.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct ActivityCardView: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            // Landscape thumbnail
            ZStack {
                // Sky blue gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Cloud
                Image(systemName: "cloud.fill")
                    .foregroundColor(.white)
                    .offset(y: -20)
                
                // Green hills
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 140))
                    path.addCurve(
                        to: CGPoint(x: 200, y: 140),
                        control1: CGPoint(x: 50, y: 100),
                        control2: CGPoint(x: 150, y: 120)
                    )
                }
                .fill(Color.green.opacity(0.5))
                .offset(y: 20)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.headline)
                Text(activity.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack {
                    Text(activity.timeAgo)
                    Spacer()
                    Text("By \(activity.author)")
                }
                .font(.caption)
            }
            .padding(.leading, 8)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    ActivityCardView(activity: Activity(
        title: "New Event",
        description: "Event description",
        author: "John Doe",
        createdAt: Date()
    ))
}
