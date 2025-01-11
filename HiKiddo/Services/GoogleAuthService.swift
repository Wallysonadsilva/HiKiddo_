//
//  GoogleAuthService.swift
//  HiKiddo
//
//  Created by W on 10/01/2025.
//

import Foundation
import Supabase
import AuthenticationServices

class GoogleAuthService {
    private let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    func signIn() async throws -> Session {
        print("Starting Google login...")
        guard let redirectURL = URL(string: "HiKiddo.HiKiddo://login-callback") else {
            throw URLError(.badURL)
        }
        
        let session = try await supabase.auth.signInWithOAuth(
            provider: .google,
            redirectTo: redirectURL
        ) { (session: ASWebAuthenticationSession) in
            print("Configuring OAuth session...")
        }
        
        print("OAuth sign in successful")
        return session
    }
}