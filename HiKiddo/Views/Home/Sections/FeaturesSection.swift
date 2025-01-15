//
//  FeaturesSection.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct FeaturesSection: View {
    let features = [
        FeatureCard(title: "Create Event", backgroundImage: "create_event", backgroundColor: .purple),
        FeatureCard(title: "Tasks", backgroundImage: "task_feature", backgroundColor: .green),
        FeatureCard(title: "Family Board", backgroundImage: "family_board", backgroundColor: .blue)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(features) { feature in
                    FeatureCardView(
                        title: feature.title,
                        backgroundImage: feature.backgroundImage,
                        backgroundColor: feature.backgroundColor
                    )
                }
            }
            .padding()
        }
    }
}
