//
//  SkillsStep.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 16/04/26.
//


import SwiftUI

struct SkillsStep: View {
    @StateObject private var theme = ThemeManager()
    @Binding var profile: DraftProfile
    
    var onNext: () -> Void
    var onBack: () -> Void
    
    @State private var query = ""
    let allSkills = ["Swift","SwiftUI","Objective-C","Kotlin","Java","Python","SQL","Figma","UX","Leadership","Communication","Strategy","Data Analysis"]
    
    var filtered: [String] {
        query.isEmpty ? allSkills : allSkills.filter { $0.localizedCaseInsensitiveContains(query) }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select your top skills").font(.title2.bold())
                .foregroundColor(theme.current.textPrimary)
            
            TextField("Search skills", text: $query)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)
            
            ScrollView {
             
            }
            
            Text("Pick up to 5 primary skills")
                .font(.footnote)
                .foregroundColor(theme.current.textSecondary)
            
            HStack {
                Spacer()
                PrimaryButton("Continue", isLoading: false, action: onNext)
                    .disabled(profile.primarySkills.isEmpty)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(theme.current.background.ignoresSafeArea())
    }
}
