//
//  FeatureCardView.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct FeatureCardView: View {
    let title: String
    let backgroundImage: String
    let backgroundColor: Color
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipped() 
            
            backgroundColor.opacity(0.1)
            
            GeometryReader { geometry in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height * 0.8))
                    path.addCurve(
                        to: CGPoint(x: geometry.size.width, y: geometry.size.height * 0.8),
                        control1: CGPoint(x: geometry.size.width * 0.3, y: geometry.size.height * 0.6),
                        control2: CGPoint(x: geometry.size.width * 0.7, y: geometry.size.height * 0.9)
                    )
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                }
                .fill(Color.primaryPurple)
            }
            

            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: 200, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    FeatureCardView(
        title: "Calendar",
        backgroundImage: "create_event",
        backgroundColor: .green
    )
}
