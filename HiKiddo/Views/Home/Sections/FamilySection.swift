//
//  FamilySection.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct FamilySection: View {
    @ObservedObject var familyViewModel: FamilyViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Family Members")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(familyViewModel.familyMembers) { member in
                        FamilyMemberView(familyMember: member)
                    }
                    
                    VStack {
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

#Preview {
    let mockViewModel = FamilyViewModel(supabaseClient: AuthViewModel().supabase)
    mockViewModel.familyMembers = [
        FamilyMember(
            id: UUID(),
            familyId: UUID(),
            profileId: UUID(),
            role: "member",
            joinedAt: Date(),
            invitedBy: nil,
            status: "active",
            name: "Alice",
            profileImageUrl: nil
        ),
        FamilyMember(
            id: UUID(),
            familyId: UUID(),
            profileId: UUID(),
            role: "member",
            joinedAt: Date(),
            invitedBy: nil,
            status: "active",
            name: "Bob",
            profileImageUrl: nil
        )
    ]
    
    return FamilySection(familyViewModel: mockViewModel)
}
