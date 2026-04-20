//
//  ProfessionalInfoScreen.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 18/04/26.
//

import SwiftUI

struct ProfessionalInfoScreen: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var companyName = ""
    @State private var selectedProfession = ""
    @State private var experienceYears = "0-1"
    @State private var jobTitle = ""
    @State private var workLocation = ""
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var navigateToProfileSummary = false
    
    @FocusState private var isCompanyFocused: Bool
    @FocusState private var isJobTitleFocused: Bool
    @FocusState private var isLocationFocused: Bool
    
    let professions = [
        "Software Engineer", "iOS Developer", "Android Developer", "Full Stack Developer",
        "Teacher", "Professor", "Doctor", "Nurse", "Marketing Manager", "Sales Executive",
        "HR Professional", "Financial Analyst", "Lawyer", "Designer", "Product Manager",
        "Data Scientist", "Architect", "Consultant", "Entrepreneur", "Other"
    ]
    
    let experienceOptions = ["0-1", "2-4", "5-7", "8+"]
    
    var isFormValid: Bool {
        !companyName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !selectedProfession.isEmpty &&
        !jobTitle.trimmingCharacters(in: .whitespaces).isEmpty
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
                                
                                Image(systemName: "briefcase.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(themeManager.current.primary)
                                    .scaleEffect(animateFields ? 1 : 0)
                            }
                            
                            Text("Professional Details")
                                .font(.title2.bold())
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("Help us understand your career background")
                                .font(.subheadline)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.bottom, 20)
                        .offset(y: animateFields ? 0 : -30)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            // Company Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Company Name")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                    .padding(.leading, 4)
                                AppTextField("e.g., Google, Microsoft, School Name", text: $companyName, icon:"building.2.fill", focused: $isCompanyFocused)

                            }
                            
                            // Job Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Job Title")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                    .padding(.leading, 4)
                                AppTextField("e.g., Senior iOS Developer", text: $jobTitle, icon: "person.badge.key.fill", focused: $isJobTitleFocused)

                            }
                            
                            // Profession
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Profession")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                    .padding(.leading, 4)
                                
                                Menu {
                                    ForEach(professions, id: \.self) { profession in
                                        Button(profession) {
                                            selectedProfession = profession
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(themeManager.current.textSecondary)
                                            .frame(width: 24)
                                        
                                        Text(selectedProfession.isEmpty ? "Select your profession" : selectedProfession)
                                            .foregroundColor(selectedProfession.isEmpty ? themeManager.current.textSecondary.opacity(0.6) : themeManager.current.textPrimary)
                                        
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
                            
                            // Experience
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Years of Experience")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                    .padding(.leading, 4)
                                
                                Picker("Experience", selection: $experienceYears) {
                                    ForEach(experienceOptions, id: \.self) { years in
                                        Text("\(years) years").tag(years)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .colorMultiply(themeManager.current.primary)
                            }
                            
                            // Work Location
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Work Location")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                                    .padding(.leading, 4)
                                
                                AppTextField("City, State or Remote",text: $workLocation,icon: "location.fill",focused: $isLocationFocused)
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
            .navigationDestination(isPresented: $navigateToProfileSummary) {
                ProfileSummaryScreen()
            }
        }
    }
    
    private func proceedToNext() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isLoading = false
            navigateToProfileSummary = true
        }
    }
}
