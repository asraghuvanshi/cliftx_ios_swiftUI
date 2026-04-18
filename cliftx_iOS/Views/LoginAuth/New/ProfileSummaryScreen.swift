//
//  ProfileSummaryScreen.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 18/04/26.
//

import SwiftUI

struct ProfileSummaryScreen: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var bio = ""
    @State private var lookingFor = ""
    @State private var selectedInterests: Set<String> = []
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var navigateToPreferences = false
    
    @FocusState private var isBioFocused: Bool
    @FocusState private var isLookingFocused: Bool
    
    let interests = [
        "Coding", "Reading", "Travel", "Fitness", "Music", "Art",
        "Cooking", "Photography", "Gaming", "Sports", "Movies", "Yoga",
        "Hiking", "Dancing", "Volunteering", "Coffee", "Tech", "Design"
    ]
    
    var isFormValid: Bool {
        !bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedInterests.isEmpty
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
                                
                                Image(systemName: "text.bubble.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(themeManager.current.primary)
                                    .scaleEffect(animateFields ? 1 : 0)
                            }
                            
                            Text("Tell your story")
                                .font(.title2.bold())
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("Help others get to know the real you")
                                .font(.subheadline)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.bottom, 20)
                        .offset(y: animateFields ? 0 : -30)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Bio
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About Me")
                                .font(.caption)
                                .foregroundColor(themeManager.current.textSecondary)
                                .padding(.leading, 4)
                            
                            TextEditor(text: $bio)
                                .frame(height: 120)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(themeManager.current.background)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(themeManager.current.background, lineWidth: 0.5)
                                        )
                                )
                                .focused($isBioFocused)
                                .scrollContentBackground(.hidden)
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("\(bio.count)/300 characters")
                                .font(.caption2)
                                .foregroundColor(themeManager.current.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 24)
                        
                        // What you're looking for
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What are you looking for?")
                                .font(.caption)
                                .foregroundColor(themeManager.current.textSecondary)
                                .padding(.leading, 4)
                            
                            TextEditor(text: $lookingFor)
                                .frame(height: 80)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(themeManager.current.background)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(themeManager.current.primary, lineWidth: 0.5)
                                        )
                                )
                                .focused($isLookingFocused)
                                .scrollContentBackground(.hidden)
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("e.g., Life partner, Serious relationship, Companionship")
                                .font(.caption2)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.horizontal, 24)
                        
                        // Interests
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select your interests")
                                .font(.caption)
                                .foregroundColor(themeManager.current.textSecondary)
                                .padding(.leading, 4)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                                ForEach(interests, id: \.self) { interest in
                                    Button(action: {
                                        if selectedInterests.contains(interest) {
                                            selectedInterests.remove(interest)
                                        } else {
                                            selectedInterests.insert(interest)
                                        }
                                    }) {
                                        Text(interest)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                Capsule()
                                                    .fill(selectedInterests.contains(interest) ? themeManager.current.primary : themeManager.current.background)
                                            )
                                            .foregroundColor(selectedInterests.contains(interest) ? .white : themeManager.current.textSecondary)
                                            .overlay(
                                                Capsule()
                                                    .stroke(themeManager.current.primary, lineWidth: 0.5)
                                            )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        
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
            .navigationDestination(isPresented: $navigateToPreferences) {
                PreferencesScreen()
            }
        }
    }
    
    private func proceedToNext() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isLoading = false
            navigateToPreferences = true
        }
    }
}
