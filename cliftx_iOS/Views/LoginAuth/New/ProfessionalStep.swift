//
//  ProfessionalStep.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 16/04/26.
//

import SwiftUI

struct ProfessionalStep: View {
    @StateObject private var theme = ThemeManager()
    @Binding var profile: DraftProfile
    
    var onNext: () -> Void
    var onBack: () -> Void
    
    let industries = ["Technology","Finance","Consulting","Healthcare","Education","Manufacturing","Media"]
    let experience = ["0–2 years","3–5 years","6–10 years","10+ years"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your professional side").font(.title2.bold()).foregroundColor(theme.current.textPrimary)
                Text("We’ll use this to suggest skills and better matches.")
                    .font(.subheadline).foregroundColor(theme.current.textSecondary)
                
                autocompleteField(title: "Industry", text: $profile.industry, suggestions: industries)
                autocompleteField(title: "Role / Title", text: $profile.role, suggestions: ["iOS Developer","Product Manager","Data Analyst","Designer","Consultant"])
                
                segmented(title: "Experience", items: experience, selection: $profile.experienceBucket)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Company (optional)").font(.subheadline.bold()).foregroundColor(theme.current.textPrimary)
                    TextField("e.g., ACME Corp", text: $profile.company)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
//                    SecondaryButton("Back", action: onBack)
                    Spacer()
                    PrimaryButton("Continue", isLoading: false, action: onNext)
                        .disabled(profile.industry.isEmpty || profile.role.isEmpty || profile.experienceBucket.isEmpty)
                }
            }
            .padding(24)
        }
        .background(theme.current.background.ignoresSafeArea())
    }
    
    @ViewBuilder
    private func segmented(title: String, items: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline.bold()).foregroundColor(theme.current.textPrimary)
            Picker("", selection: selection) {
                ForEach(items, id: \.self) { item in Text(item).tag(item) }
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    private func autocompleteField(title: String, text: Binding<String>, suggestions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline.bold()).foregroundColor(theme.current.textPrimary)
            TextField("Type to search…", text: text)
                .textFieldStyle(.roundedBorder)
            if !text.wrappedValue.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(suggestions.filter { $0.localizedCaseInsensitiveContains(text.wrappedValue) }, id: \.self) { s in
                            Chip(text: s) { text.wrappedValue = s }
                        }
                    }
                }
            }
        }
    }
}
