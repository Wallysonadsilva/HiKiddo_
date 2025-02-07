//
//  FamilyMemberView.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//
import Foundation
import SwiftUI

struct FamilyMemberView: View {
    let familyMember: FamilyMember
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                if let imageUrl = familyMember.profile?.avatarUrl,
                   !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }
            }
            Text(familyMember.profile?.fullName ?? "Unknown")
                .font(.caption)
        }
    }
}

#Preview {
    FamilyMemberView(familyMember: FamilyMember(
        id: UUID(),
        familyId: UUID(),
        profileId: UUID(),
        role: "Parent",
        joinedAt: Date(),
        invitedBy: nil,
        status: "Active",
        profile: Profile(
            fullName: "Alice Johnson",
            avatarUrl: "https://via.placeholder.com/150"
        )
    ))
}
