//
//  PersonalInfoScreen.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 18/04/26.
//
 

import SwiftUI

struct PersonalInfoScreen: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName = ""
    @State private var selectedGender = ""
    @State private var dateOfBirth = Date()
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var navigateToProfilePhoto = false
    
    @FocusState private var isNameFocused: Bool
    
    let genders = ["Male", "Female", "Non-binary", "Prefer not to say"]
    
    var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !selectedGender.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.current.background
                    .ignoresSafeArea()
                
                // Animated gradient orbs
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                themeManager.current.primary.opacity(colorScheme == .dark ? 0.45 : 0.25),
                                themeManager.current.accent.opacity(colorScheme == .dark ? 0.18 : 0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 300, height: 300)
                    .position(x: -50, y: 100)
                    .blur(radius: colorScheme == .dark ? 90 : 60)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                themeManager.current.accent.opacity(colorScheme == .dark ? 0.35 : 0.18),
                                themeManager.current.primary.opacity(colorScheme == .dark ? 0.12 : 0.08)
                            ],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                    .frame(width: 250, height: 250)
                    .position(x: UIScreen.main.bounds.width + 40, y: UIScreen.main.bounds.height - 300)
                    .blur(radius: colorScheme == .dark ? 80 : 55)
                
                ScrollView {
                    VStack(spacing: 30) {
                        Spacer(minLength: 40)
                        
                        // Header
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(themeManager.current.primary.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                    .scaleEffect(animateFields ? 1 : 0.5)
                                    .opacity(animateFields ? 1 : 0)
                                
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 45))
                                    .foregroundColor(themeManager.current.primary)
                                    .scaleEffect(animateFields ? 1 : 0)
                            }
                            
                            Text("Tell us about yourself")
                                .font(.title2.bold())
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("Let's start with your basic information")
                                .font(.subheadline)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.bottom, 20)
                        .offset(y: animateFields ? 0 : -30)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Form Fields
                        VStack(spacing: 24) {
                            // Full Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                    .padding(.leading, 4)
                                
                                AppTextField(
                                    "Enter your full name",
                                    text: $fullName,
                                    kind: .plain,
                                    systemIcon: "person.fill",
                                    focused: $isNameFocused
                                )
                            }
                            
                            // Gender Selection
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Gender")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                    .padding(.leading, 4)
                                
                                Menu {
                                    ForEach(genders, id: \.self) { gender in
                                        Button(gender) {
                                            selectedGender = gender
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "gendersign")
                                            .foregroundColor(themeManager.current.textSecondary)
                                            .frame(width: 24)
                                        
                                        Text(selectedGender.isEmpty ? "Select gender" : selectedGender)
                                            .foregroundColor(selectedGender.isEmpty ? themeManager.current.textSecondary.opacity(0.6) : themeManager.current.textPrimary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(themeManager.current.textSecondary)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(themeManager.current.background)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(themeManager.current.primary, lineWidth: 0.5)
                                            )
                                    )
                                }
                            }
                            
                            // Date of Birth
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date of Birth")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                    .padding(.leading, 4)
                                
                                DatePicker(
                                    "Select date",
                                    selection: $dateOfBirth,
                                    in: ...Date(),
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .tint(themeManager.current.primary)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(themeManager.current.background)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(themeManager.current.primary, lineWidth: 0.5)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .offset(y: animateFields ? 0 : 30)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Continue Button
                        PrimaryButton("Continue", isLoading: isLoading) {
                            proceedToNext()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1 : 0.6)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.body)
                            Text("Back")
                        }
                        .foregroundColor(themeManager.current.textSecondary)
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.5)) {
                    animateFields = true
                }
            }
            .navigationDestination(isPresented: $navigateToProfilePhoto) {
                ProfilePhotoScreen()
            }
        }
    }
    
    private func proceedToNext() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isLoading = false
            navigateToProfilePhoto = true
        }
    }
}
