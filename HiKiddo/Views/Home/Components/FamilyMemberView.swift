//
//  FamilyMemberView.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct FamilyMemberView: View {
    let name: String
    let image: String
    
    var body: some View {
        VStack {
            ZStack {
                // Similar landscape background as feature card but smaller
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                // Cloud and hill elements
            }
            Text(name)
                .font(.caption)
        }
    }
}
