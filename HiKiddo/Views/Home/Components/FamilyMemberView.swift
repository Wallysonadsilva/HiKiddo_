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
                // Similar landscape background as feature card but smaller
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(familyMember.profileImage)  // Use the profile image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)  // Slightly smaller than circle
                    .clipShape(Circle())
                
                // Cloud and hill elements
            }
            Text(familyMember.name)
                .font(.caption)
        }
    }
}

#Preview {
    FamilyMemberView(familyMember: FamilyMember(
        name: "John Doe",
        profileImage: "create_event"
    ))
}
