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
    public init(viewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @State private var authMode: AuthMode = .login
    @State private var rememberMe: Bool = false
    @State private var showError: Bool = false
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    
    enum AuthMode {
        case login
        case register
    }
    
    var body: some View {
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
                    .padding(.top, -40)
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
                        VStack(spacing: 20) {
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
                        .padding(.top, 10)
                        
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
                        .padding(.top, 10)
                        
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
        }
        .navigationBarHidden(true)
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
