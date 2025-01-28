//
//  FamilyGroup.swift
//  HiKiddo
//
//  Created by W on 27/01/2025.
//

import Foundation

struct FamilyGroup: Codable, Identifiable {
    let id: UUID
    let name: String
    let createdAt: Date
    let createdBy: UUID
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case createdBy = "created_by"
        case updatedAt = "updated_at"
    }
}

struct FamilyMember: Codable, Identifiable {
    let id: UUID
    let familyId: UUID
    let profileId: UUID
    let role: String
    let joinedAt: Date
    let invitedBy: UUID?
    let status: String
    let name: String?
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case familyId = "family_id"
        case profileId = "profile_id"
        case role
        case joinedAt = "joined_at"
        case invitedBy = "invited_by"
        case status
        case name
        case profileImageUrl = "profile_image_url"
    }
}
