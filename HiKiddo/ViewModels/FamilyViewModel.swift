//
//  FamilyViewModel.swift
//  HiKiddo
//
//  Created by W on 27/01/2025.
//
import Foundation
import Supabase

@MainActor
class FamilyViewModel: ObservableObject {
    @Published var familyGroup: FamilyGroup?
    @Published var familyMembers: [FamilyMember] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var belongsToFamilyGroup = false
    
    private let supabase: SupabaseClient
    
    init(supabaseClient: SupabaseClient) {
        self.supabase = supabaseClient
    }
    
    func checkFamilyMembership() async {
        isLoading = true
        defer { isLoading = false }
        do {
            guard let userId = supabase.auth.currentUser?.id else {
                isLoading = false
                return
            }

            let query = supabase.from("family_members")
                .select("""
                    id, family_id, profile_id, role, joined_at, status,
                    profiles!family_members_profile_id_fkey ( full_name, avatar_url )
                """)
                .eq("profile_id", value: userId.uuidString)


            let members: [FamilyMember] = try await query.execute().value
            
            DispatchQueue.main.async {
                self.belongsToFamilyGroup = !members.isEmpty
                if !members.isEmpty {
                    self.familyMembers = members
                    self.familyGroup = FamilyGroup(id: members[0].familyId, name: "Family Name", createdAt: Date(), createdBy: members[0].profileId, updatedAt: Date())
                }
            }
        } catch {
            print("❌ Error fetching family membership: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }



    
    func createFamily(name: String) async -> Bool {
        isLoading = true
        do {
            guard let userId = supabase.auth.currentUser?.id else {
                isLoading = false
                return false
            }
            
            // Create the family group
            let newFamily: [String: String] = [
                "name": name,
                "created_by": userId.uuidString
            ]
            
            // Add `try` before the full query chain
            let family: FamilyGroup = try await supabase.from("family_groups")
                .insert(newFamily)
                .select()
                .single()
                .execute()
                .value
            
            // Create member with string values
            let member: [String: String] = [
                "family_id": family.id.uuidString,
                "profile_id": userId.uuidString,
                "role": "admin",
                "status": "active"
            ]
            
            try await supabase.from("family_members")
                .insert(member)
                .execute()
            
            familyGroup = family
            await checkFamilyMembership()
            isLoading = false
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    

}
    
