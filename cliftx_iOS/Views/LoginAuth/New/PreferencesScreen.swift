//
//  PreferencesScreen.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 18/04/26.
//


import SwiftUI

struct PreferencesScreen: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var minAge = 22
    @State private var maxAge = 35
    @State private var selectedProfessions: Set<String> = []
    @State private var locationPreference = "Local"
    @State private var intent = "Life partner"
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var navigateToHome = false
    
    let professions = [
        "Software Engineer", "Teacher", "Doctor", "Marketing", "Sales",
        "HR", "Finance", "Designer", "Product Manager", "Data Scientist"
    ]
    
    let locationOptions = ["Local", "Nearby cities", "Anywhere"]
    let intentOptions = ["Life partner", "Serious relationship", "Friendship first"]
    
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
                                
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 40))
                                    .foregroundColor(themeManager.current.primary)
                                    .scaleEffect(animateFields ? 1 : 0)
                            }
                            
                            Text("Your Preferences")
                                .font(.title2.bold())
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("Tell us what you're looking for")
                                .font(.subheadline)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.bottom, 20)
                        .offset(y: animateFields ? 0 : -30)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Age Range
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Age Range")
                                .font(.caption)
                                .foregroundColor(themeManager.current.textSecondary)
                                .padding(.leading, 4)
                            
                            HStack {
                                Text("\(minAge)")
                                    .font(.title3.bold())
                                    .foregroundColor(themeManager.current.primary)
                                    .frame(width: 40)
                                
                                Slider(value: Binding(
                                    get: { Double(minAge) },
                                    set: { minAge = Int($0) }
                                ), in: 18...60, step: 1)
                                .tint(themeManager.current.primary)
                                
                                Text("\(maxAge)")
                                    .font(.title3.bold())
                                    .foregroundColor(themeManager.current.primary)
                                    .frame(width: 40)
                            }
                            
                            HStack {
                                Text("18")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                Spacer()
                                Text("60")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                            }
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
                        .padding(.horizontal, 24)
                        
                        // Profession Preferences
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preferred Professions")
                                .font(.caption)
                                .foregroundColor(themeManager.current.textSecondary)
                                .padding(.leading, 4)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                                ForEach(professions, id: \.self) { profession in
                                    Button(action: {
                                        if selectedProfessions.contains(profession) {
                                            selectedProfessions.remove(profession)
                                        } else {
                                            selectedProfessions.insert(profession)
                                        }
                                    }) {
                                        Text(profession)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                Capsule()
                                                    .fill(selectedProfessions.contains(profession) ? themeManager.current.primary : themeManager.current.background)
                                            )
                                            .foregroundColor(selectedProfessions.contains(profession) ? .white : themeManager.current.textSecondary)
                                            .overlay(
                                                Capsule()
                                                    .stroke(themeManager.current.primary, lineWidth: 0.5)
                                            )
                                    }
                                }
                            }
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
                        .padding(.horizontal, 24)
                        
                        // Location Preference
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Location Preference")
                                .font(.caption)
                                .foregroundColor(themeManager.current.textSecondary)
                                .padding(.leading, 4)
                            
                            Picker("Location", selection: $locationPreference) {
                                ForEach(locationOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                            .colorMultiply(themeManager.current.primary)
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
                        .padding(.horizontal, 24)
                        
                        // Intent
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Relationship Intent")
                                .font(.caption)
                                .foregroundColor(themeManager.current.textSecondary)
                                .padding(.leading, 4)
                            
                            Picker("Intent", selection: $intent) {
                                ForEach(intentOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                            .colorMultiply(themeManager.current.primary)
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
                        .padding(.horizontal, 24)
                        
                        // Complete Button
                        PrimaryButton("Complete Setup", isLoading: isLoading) {
                            completeSetup()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
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
            .navigationDestination(isPresented: $navigateToHome) {
//                HomeScreen() // Your main app home screen
            }
        }
    }
    
    private func completeSetup() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            navigateToHome = true
        }
    }
}
