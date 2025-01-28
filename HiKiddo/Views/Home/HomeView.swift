//
//  HomeView.swift
//  HiKiddo
//
//  Created by W on 14/01/2025.
//

import Foundation
import SwiftUI

struct HomeView: View {
   @StateObject var authViewModel: AuthViewModel
   @StateObject private var familyViewModel: FamilyViewModel
   @State private var showCreateFamilyGroupSheet = false
   @State private var settingsDetent = PresentationDetent.medium
   @State private var familyName = ""
   
   init(authViewModel: AuthViewModel) {
       _authViewModel = StateObject(wrappedValue: authViewModel)
       _familyViewModel = StateObject(wrappedValue: FamilyViewModel(supabaseClient: authViewModel.supabase))
   }
   
   var body: some View {
       VStack(spacing: 0) {
           ZStack {
               Color.primaryPurple.opacity(1.0)
                   .clipShape(CustomShape())
                   .ignoresSafeArea(edges: .top)
                   .frame(height: 150)
               
               // Header
               HStack {
                   // Profile Image and Greeting
                   HStack {
                       AsyncImage(url: authViewModel.profileImageURL) { image in
                           image
                               .resizable()
                               .scaledToFill()
                               .frame(width: 50, height: 50)
                               .clipShape(Circle())
                               .overlay(
                                   Circle()
                                       .stroke(Color.primeryYellow.opacity(0.9), lineWidth: 5)
                               )
                       } placeholder: {
                           Circle()
                               .stroke(Color.primeryYellow.opacity(0.9), lineWidth: 5)
                               .fill(Color.gray.opacity(0.7))
                               .frame(width: 50, height: 50)
                               .overlay(
                                   Image(systemName: "person.circle.fill")
                                       .foregroundColor(.white)
                               )
                       }
                       
                       VStack(alignment: .leading) {
                           Text("Morning!")
                               .font(.headline)
                               .foregroundColor(.white)
                           Text("\(authViewModel.userName)")
                               .font(.subheadline)
                               .foregroundColor(.gray)
                       }
                   }
                   
                   Spacer()
                   
                   // Settings and Notifications
                   HStack(spacing: 20) {
                       Button(action: {}) {
                           Image(systemName: "gear")
                               .foregroundColor(.white)
                       }
                       Button(action: {}) {
                           Image(systemName: "bell")
                               .foregroundColor(.white)
                       }
                   }
               }
               .padding(.horizontal)
               .padding(.top, -40)
           }
           
           // Main Content: Conditional sections
           if familyViewModel.isLoading {
               ProgressView()
           } else if familyViewModel.belongsToFamilyGroup {
               VStack(spacing: 0) {
                   FeaturesSection()
                   ScrollView {
                       VStack(spacing: 20) {
                           FamilySection(familyViewModel: familyViewModel)
                           ActivitySection()
                       }
                       .padding(.top)
                   }
               }
           } else {
               //Content for users without a family group
               VStack(spacing: 20) {
                   Spacer().frame(height: 20)
                   
                   Image("create_family")
                       .resizable()
                       .frame(width: 300, height: 300)
                       .foregroundColor(.primary)
                   
                   Text("You are not part of a family group yet.")
                       .font(.headline)
                       .foregroundColor(Color.gray)
                       .multilineTextAlignment(.center)
                       .padding()
                   
                   Button(action: {
                       showCreateFamilyGroupSheet = true
                   }) {
                       Text("Create a Family")
                           .foregroundColor(.white)
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(Color.primaryPurple)
                           .cornerRadius(10)
                           .padding(.horizontal)
                   }
                   .sheet(isPresented: $showCreateFamilyGroupSheet) {
                       CreateFamilySheet(
                           familyName: $familyName,
                           isPresented: $showCreateFamilyGroupSheet,
                           familyViewModel: familyViewModel
                       )
                   }
                   Spacer()
               }
           }
       }
       .navigationBarBackButtonHidden(true)
       .task {
           Task {
               try? await authViewModel.getUserName()
               try? await authViewModel.getUserProfile()
               await familyViewModel.checkFamilyMembership()
           }
       }
   }
}

struct CreateFamilySheet: View {
   @Binding var familyName: String
   @Binding var isPresented: Bool
   @ObservedObject var familyViewModel: FamilyViewModel
   @State private var settingsDetent = PresentationDetent.medium
   
   var body: some View {
       NavigationView {
           VStack(spacing: 20) {
               Text("Create Your Family Group")
                   .font(.title2)
                   .fontWeight(.bold)
                   .padding(.top, 20)
               
               TextField("Family Name", text: $familyName)
                   .frame(width: 220)
                   .padding(15)
                   .multilineTextAlignment(.center)
                   .overlay(
                       RoundedRectangle(cornerRadius: 10)
                           .stroke(Color.primeryYellow)
                   )
               
               if familyViewModel.isLoading {
                   ProgressView()
               } else {
                   Button(action: {
                       Task {
                           if await familyViewModel.createFamily(name: familyName) {
                               isPresented = false
                               familyName = ""
                           }
                       }
                   }) {
                       Text("Create Family")
                           .foregroundColor(.white)
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.primaryPurple)
                           .cornerRadius(10)
                   }
                   .padding(.horizontal, 60)
                   .disabled(familyName.isEmpty)
               }
               
               if let errorMessage = familyViewModel.errorMessage {
                   Text(errorMessage)
                       .foregroundColor(.red)
                       .font(.caption)
                       .multilineTextAlignment(.center)
                       .padding()
               }
               
               Spacer()
           }
           .navigationBarItems(trailing: Button(action: {
               isPresented = false
           }) {
               Image(systemName: "xmark.circle")
                   .foregroundColor(.gray)
                   .font(.title2)
           })
       }
       .presentationDetents(
           [.medium, .large],
           selection: $settingsDetent
       )
   }
}

struct customShape: Shape {
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

struct familySection: View {
   let familyGroup: FamilyGroup?
   
   var body: some View {
       VStack(alignment: .leading, spacing: 10) {
           Text("Family Group")
               .font(.headline)
               .padding(.horizontal)
           
           if let family = familyGroup {
               VStack(alignment: .leading) {
                   Text(family.name)
                       .font(.title2)
                       .fontWeight(.bold)
               }
               .padding()
               .frame(maxWidth: .infinity)
               .background(Color.white)
               .cornerRadius(10)
               .shadow(radius: 2)
               .padding(.horizontal)
           }
       }
   }
}

#Preview {
   HomeView(authViewModel: AuthViewModel())
}
