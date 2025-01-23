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
           HStack {
               Text("Recent Activities")
                   .font(.title2)
                   .fontWeight(.bold)
               Spacer()
               Button("See all") {
                   // Action
               }
               .foregroundColor(.blue)
           }
           .padding(.horizontal)
           
           VStack(spacing: 12) {
               ForEach(0..<3) { _ in
                   ActivityCardView(activity: Activity(
                       title: "New Calendar Event Created",
                       description: "Family gathering at richmond park, Bring snacks and cozy clothes",
                       author: "Karen",
                       createdAt: Date().addingTimeInterval(-25 * 60)
                   ))
               }
           }
           .padding()
        }
    }
}
