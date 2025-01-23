//
//  FamilySection.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct FamilySection: View {
    let familyMembers = [
        FamilyMember(name: "Alice", profileImage: "create_event"),
        FamilyMember(name: "Elle", profileImage: "task_feature"),
        FamilyMember(name: "Bob", profileImage: "family_board")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Family Members")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(familyMembers) { member in // Use ForEach with your array
                        FamilyMemberView(familyMember: member)
                    }
                    
                    VStack{
                        // Add Member Button
                        Button(action: {
                            // Add member action
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "plus")
                                    .foregroundColor(.gray)
                            }
                        }
                        Text(" ")
                            .font(.caption)
                    }
                }
                .padding()
            }
        }
    }
}
