//
//  OnboardingFlowView.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 16/04/26.
//


import SwiftUI

struct OnboardingFlowView: View {
    @State private var step: Int = 0
    let totalSteps = 6
    let email: String
    
    // Shared profile model during onboarding
    @State private var profile = DraftProfile()
    
    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: Double(step+1), total: Double(totalSteps))
                .tint(ThemeManager().current.primary)
                .padding(.horizontal, 24)
                .padding(.top, 16)
            
            TabView(selection: $step) {
                BasicDetailsStep(profile: $profile, onNext: next).tag(0)
                ProfessionalStep(profile: $profile, onNext: next, onBack: back).tag(1)
                SkillsStep(profile: $profile, onNext: next, onBack: back).tag(2)
                PreferencesStep(profile: $profile, onNext: next, onBack: back).tag(3)
                LifestyleBioStep(profile: $profile, onNext: next, onBack: back).tag(4)
                PhotosReviewStep(profile: $profile, onFinish: finish, onBack: back).tag(5)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func next() {
        withAnimation { step = min(step + 1, totalSteps - 1) }
    }
    private func back() {
        withAnimation { step = max(step - 1, 0) }
    }
    private func finish() {
        // Submit profile to backend, then route to home
        // e.g., dismiss or navigate to main app
    }
}

struct DraftProfile {
    // Basic
    var gender: String = ""
    var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -25, to: .now) ?? .now
    var location: String = ""
    var showApproxLocation: Bool = true
    
    // Professional
    var industry: String = ""
    var role: String = ""
    var experienceBucket: String = ""
    var company: String = ""
    
    // Skills
    var primarySkills: [String] = []
    var secondarySkills: [String] = []
    var softSkills: [String] = []
    
    // Preferences
    var preferredSkills: [String] = []
    var preferredIndustries: [String] = []
    var ageRange: ClosedRange<Int> = 24...34
    var distanceKm: Int = 25
    var workStyle: String = "Hybrid"
    
    // Lifestyle & bio
    var interests: [String] = []
    var languages: [String] = []
    var bio: String = ""
    var promptAnswers: [String:String] = [:]
    
    // Media
    var photos: [UIImage] = []
}