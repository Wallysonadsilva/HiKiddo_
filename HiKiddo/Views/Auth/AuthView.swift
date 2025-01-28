//
//  AuthView.swift
//  HiKiddo
//
//  Created by W on 07/01/2025.
//

import Foundation
import SwiftUI
import Supabase

struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel
    @StateObject private var familyViewModel: FamilyViewModel
    public init(viewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _familyViewModel = StateObject(wrappedValue: FamilyViewModel(supabaseClient: viewModel.supabase))
    }
    
    @State private var authMode: AuthMode = .login
    @State private var rememberMe: Bool = false
    @State private var showError: Bool = false
    
    @State private var isAppleSignInLoading = false
    @State private var isGoogleSignInLoading = false
    @State private var isFacebookSignInLoading = false
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    
    enum AuthMode {
        case login
        case register
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                // Top curved section with an image overlay
                ZStack {
                    Color.primaryPurple.opacity(1.0)
                        .clipShape(CustomShape())
                        .ignoresSafeArea(edges: .top)
                    
                    // Add the image
                    Image("Auth_Image2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(.top, -30)
                }
                .frame(height: 200)
                
                Color.white
                    .ignoresSafeArea()
                    .safeAreaInset(edge: .bottom) {
                        VStack(spacing: 25) {
                            
                            
                            // Welcome Text
                            VStack(spacing: 8) {
                                Text(authMode == .login ? "Welcome Back" : "Create Account")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.black)
                                
                                Text(authMode == .login ? "Login to your account" : "Sign up for a new account")
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.8))
                            }
                            
                            // Form Fields
                            VStack(spacing: 15) {
                                if authMode == .register {
                                    CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $fullName, accessibilityID: "fullNameField")
                                }
                                
                                CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email, accessibilityID: "emailField")
                                    .accessibilityIdentifier("emailField")
                                
                                CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true, accessibilityID: "passwordField")
                                    .accessibilityIdentifier("passwordField")
                            }
                            .padding(.horizontal, 25)
                            
                            // Remember me and Forgot Password
                            if authMode == .login {
                                HStack {
                                    Toggle("Remember me", isOn: .constant(false))
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Button("Forgot Password?") {
                                        // Handle forgot password
                                    }
                                    .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 25)
                            }
                            
                            // Login/Signup Button
                            Button(action: {
                                Task {
                                    do {
                                        if authMode == .login {
                                            try await viewModel.signIn(email: email, password: password)
                                        } else {
                                            try await viewModel.signUp(email: email, password: password, fullName: fullName)
                                        }
                                    } catch {
                                        print("Auth error: \(error)")
                                        showError = true
                                    }
                                }
                            }) {
                                Text(authMode == .login ? "LOGIN" : "SIGN UP")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.primaryPurple.opacity(1.0))
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                            .accessibilityIdentifier(authMode == .login ? "signInSubmitButton" : "signUpSubmitButton")
                            .padding(.horizontal, 25)
                            .padding(.top, 5)
                            
                            // Switch between Login/Signup
                            HStack {
                                Text(authMode == .login ? "Don't have an account?" : "Already have an account?")
                                    .foregroundColor(.gray)
                                Button(authMode == .login ? "Sign up" : "Login") {
                                    withAnimation {
                                        authMode = authMode == .login ? .register : .login
                                    }
                                }
                                .accessibilityIdentifier(authMode == .login ? "signUpButton" : "signInButton")
                                .foregroundColor(Color.primaryPurple)
                                .fontWeight(.bold)
                            }
                            
                            // Add Divider with "or" text
                            HStack {
                                VStack { Divider() }.padding(.horizontal, 25)
                                Text("OR")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                VStack { Divider() }.padding(.horizontal, 25)
                            }
                            .padding(.vertical, 5)
                            
                            // Social Media Buttons Row
                            HStack(spacing: 20) {
                                // Apple Sign In Button
                                Button(action: {
                                    isAppleSignInLoading = true
                                    // Apple sign in logic will be added later
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.black))
                                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                                            .frame(width: 60, height: 60)
                                        
                                        if isAppleSignInLoading {
                                            ProgressView()
                                        } else {
                                            Image(systemName: "apple.logo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                
                                // Google Sign In Button
                                Button(action: {
                                    isGoogleSignInLoading = true
                                    Task {
                                        await viewModel.handleGoogleSignIn(familyViewModel: familyViewModel)
                                        isGoogleSignInLoading = false
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.systemBackground))
                                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                                            .frame(width: 60, height: 60)
                                        
                                        if isGoogleSignInLoading {
                                            ProgressView()
                                        } else {
                                            Image("google_logo") // Add this to your assets
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                }
                                
                                // Facebook Sign In Button
                                Button(action: {
                                    isFacebookSignInLoading = true
                                    Task {
                                        await viewModel.handleFacebookSignIn(familyViewModel: familyViewModel)
                                        isFacebookSignInLoading = false
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 66/255, green: 103/255, blue: 178/255))
                                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                                            .frame(width: 60, height: 60)
                                        
                                        if isFacebookSignInLoading {
                                            ProgressView()
                                                .tint(.white)
                                        } else {
                                            Image("facebook_logo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                        }
                                    }
                                }
                            }
                            .padding(.top, 5)
                            
                            Spacer()
                        }
                        .alert("Error", isPresented: $showError) {
                            Button("OK") {
                                showError = false
                                viewModel.errorMessage = nil
                            }
                            .accessibilityIdentifier("errorButton")
                        } message: {
                            Text(viewModel.errorMessage ?? "")
                                .accessibilityIdentifier("errorMessage")
                        }
                    }
                    .navigationDestination(isPresented: $viewModel.isAuthenticated){
                        HomeView(authViewModel: AuthViewModel(), familyViewModel: familyViewModel)
                    }
            }
            .navigationBarHidden(true)
        }
    }
}

// Custom TextField View
struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var accessibilityID: String? = nil
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .accessibilityIdentifier(accessibilityID ?? "")
            } else {
                TextField(placeholder, text: $text)
                    .accessibilityIdentifier(accessibilityID ?? "")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// Custom Shape for curve
struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height - 60))
        
        // Create the curve
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height - 60),
            control: CGPoint(x: rect.width / 2, y: rect.height + 20)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.closeSubpath()
        
        return path
    }
}



#Preview {
    AuthView(viewModel: AuthViewModel(supabase: Database.client))
}
