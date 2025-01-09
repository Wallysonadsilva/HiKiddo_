//
//  AuthViewModel.swift
//  HiKiddo
//
//  Created by W on 08/01/2025.
//

import Foundation
import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    let supabase: SupabaseClient
    
    init(supabase: SupabaseClient = Database.client) {
        self.supabase = supabase
    }
    
    func signUp(email: String, password: String, fullName: String) async throws {
        // Validate input fields
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty"
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email cannot be empty"])
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Password cannot be empty"])
        }
        
        guard !fullName.isEmpty else {
            errorMessage = "Full name cannot be empty"
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Full name cannot be empty"])
        }
        
        do {
            // Check if user exists
            try await supabase.auth.signIn(
                email: email,
                password: password
            )
            errorMessage = "User already exists"
            throw NSError(domain: "Auth", code: 409, userInfo: [NSLocalizedDescriptionKey: "User already exists"])
        } catch let error as NSError where error.domain == "Auth" {
            throw error
        } catch {
            // Proceed with signup if user doesn't exist
            let authResponse = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: ["full_name": AnyJSON(fullName)]
            )
            print("Sign up successful: \(authResponse)")
        }
    }
    
    func signIn(email: String, password: String) async throws {
        // Validate input fields
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty"
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email cannot be empty"])
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Password cannot be empty"])
        }
        
        do {
            let authResponse = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            print("Sign in successful: \(authResponse)")
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
}
