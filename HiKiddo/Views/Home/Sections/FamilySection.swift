//
//  FamilySection.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct FamilySection: View {
    //let familyMembers: [FamilyMember] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Family Members")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<4) { _ in
                        FamilyMemberView(name: "Member", image: "placeholder")
                    }
                    
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
                }
                .padding()
            }
        }
    }
}
