//
//  ContentView.swift
//  HiKiddo
//
//  Created by W on 06/01/2025.
//

import SwiftUI

struct WelcomeView: View {
    @State private var navigateToAuth = false
    @StateObject private var authViewModel = AuthViewModel(supabase: Database.client)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // Image
                Image("Welcome_Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .padding(.top, 50)
                
                // Welcome Message
                Text("Welcome to HiKiddo!")
                    .font(.largeTitle)
                    .bold()
                
                Text("Your journey starts here")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Start Button
                NavigationLink(destination: AuthView(viewModel: authViewModel)) {
                    Text("Get Started")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryPurple)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

// Preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

