//
//  FacebookAuthService.swift
//  HiKiddo
//
//  Created by W on 09/01/2025.
//
import Foundation
import Supabase
import AuthenticationServices

class FacebookAuthService {
    private let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    func signIn() async throws -> Session {
        print("Starting Facebook login...")
        guard let redirectURL = URL(string: "HiKiddo.HiKiddo://login-callback") else {
            throw URLError(.badURL) // Throw an error if the URL is invalid
        }
        
        let session = try await supabase.auth.signInWithOAuth(
            provider: .facebook,
            redirectTo: redirectURL
        ) { (session: ASWebAuthenticationSession) in
            print("Configuring OAuth session...")
        }
        
        print("OAuth sign in successful")
        return session
    }

}
