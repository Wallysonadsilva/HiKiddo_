//
//  ActivitySection.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct ActivitySection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Activities")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(0..<3) { _ in
                    ActivityCardView(
                        title: "New Calendar Event Created",
                        description: "Family gathering at richmond park, Bring snacks and cozy clothes",
                        timeAgo: "25 mins ago",
                        author: "Karen"
                    )
                }
            }
            .padding()
        }
    }
}
