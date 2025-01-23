//
//  ActivityCard.swift
//  HiKiddo
//
//  Created by W on 23/01/2025.
//

import Foundation
import SwiftUI

struct Activity: Identifiable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let author: String
    let createdAt: Date
    
    var timeAgo: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: createdAt, to: now)
        
        if let minutes = components.minute, minutes < 60 {
            return "\(minutes)m ago"
        } else if let hours = components.hour, hours < 24 {
            return "\(hours)h ago"
        } else if let days = components.day {
            return "\(days)d ago"
        }
        return "Just now"
    }
}
