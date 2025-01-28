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
    private lazy var facebookAuthService = FacebookAuthService(supabase: supabase)
    private lazy var googleAuthService = GoogleAuthService(supabase: supabase)
    @Published var userName: String = ""
    @Published var profileImageURL: URL?
    
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
            self.isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // Facebook Sign in
    func handleFacebookSignIn(familyViewModel: FamilyViewModel) async {
            do {
                let session = try await facebookAuthService.signIn()
                
                try await getUserName()
                try await getUserProfile()
                
                await familyViewModel.checkFamilyMembership()
                
                await MainActor.run {
                    self.isAuthenticated = true
                }
                print("Successfully signed in with Facebook:  \(session)")
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    
    // Google Sign in
    func handleGoogleSignIn(familyViewModel: FamilyViewModel) async {
        do {
            let session = try await googleAuthService.signIn()
            try await getUserName()
            try await getUserProfile()
            
            await familyViewModel.checkFamilyMembership()
            
            await MainActor.run {
                self.isAuthenticated = true
            }
            print("Successfully signed in with Google:  \(session)")
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getUserName() async throws {
        let metadata = try await supabase.auth.session.user.userMetadata
        if let fullName = metadata["full_name"]?.value as? String {
            await MainActor.run {
                self.userName = fullName
            }
        }
    }
    
    func getUserProfile() async throws {
       let metadata = try await supabase.auth.session.user.userMetadata
       if let avatarURL = metadata["avatar_url"]?.value as? String,
          let url = URL(string: avatarURL) {
           await MainActor.run {
               self.profileImageURL = url
               print("Set profile image URL:", url)
           }
       }
    }
    
    
}
