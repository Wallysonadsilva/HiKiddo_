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
        guard let redirectURL = URL(string: "hikiddo.hikiddo://login-callback") else {
            throw URLError(.badURL)
        }
        
        let session = try await supabase.auth.signInWithOAuth(
            provider: .google,
            redirectTo: redirectURL,
            scopes: "email profile",
            queryParams: [
                (name: "prompt", value: "select_account"),
                (name: "access_type", value: "offline")
            ]
        ) { (webAuthSession: ASWebAuthenticationSession) in
            print("Configuring OAuth session...")
            webAuthSession.prefersEphemeralWebBrowserSession = false
        }
        
        print("OAuth sign in successful")
        return session
    }
}
