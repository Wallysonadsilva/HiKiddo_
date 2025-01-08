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
        let authResponse = try await supabase.auth.signUp(
            email: email,
            password: password,
            data: ["full_name": AnyJSON(fullName)]
        )
        print("Sign up successful: \(authResponse)")
    }
    
    func signIn(email: String, password: String) async throws {
        let authResponse = try await supabase.auth.signIn(
            email: email,
            password: password
        )
        print("Sign in successful: \(authResponse)")
    }
}
