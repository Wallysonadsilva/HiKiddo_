//
//  FeatureCard.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//
import SwiftUI

struct FeatureCard: Identifiable {
    let id = UUID()
    let title: String
    let backgroundImage: String  // Image name from assets
    let backgroundColor: Color   // Custom background color for each card
}
