//
//  BasicDetailsStep.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 16/04/26.
//

import SwiftUI

struct BasicDetailsStep: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var theme = ThemeManager()
    @Binding var profile: DraftProfile
    
    var onNext: () -> Void
    
    let genders = ["Woman", "Man", "Non-binary", "Prefer not to say"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header(title: "Tell us about you",
                       subtitle: "This helps us personalize your experience.")
                
                segmentedPicker(title: "Gender", items: genders, selection: $profile.gender)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date of birth")
                        .foregroundColor(theme.current.textPrimary)
                        .font(.subheadline.bold())
                    DatePicker("", selection: $profile.dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("City or Area")
                        .foregroundColor(theme.current.textPrimary)
                        .font(.subheadline.bold())
                    TextField("e.g., Bengaluru, Indiranagar", text: $profile.location)
                        .textFieldStyle(.roundedBorder)
                }
                
                Toggle("Show approximate location only", isOn: $profile.showApproxLocation)
                    .tint(theme.current.primary)
                    .foregroundColor(theme.current.textSecondary)
                
                HStack {
//                    SecondaryButton("Back") { dismiss() }
                    Spacer()
                    PrimaryButton("Continue", isLoading: false) { onNext() }
                        .disabled(profile.gender.isEmpty || profile.location.isEmpty)
                }
            }
            .padding(24)
        }
        .background(theme.current.background.ignoresSafeArea())
    }
    
    @ViewBuilder
    private func header(title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Text(title).font(.title2.bold()).foregroundColor(theme.current.textPrimary)
            Text(subtitle).font(.subheadline).foregroundColor(theme.current.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func segmentedPicker(title: String, items: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline.bold()).foregroundColor(theme.current.textPrimary)
            Picker("", selection: selection) {
                ForEach(items, id: \.self) { item in
                    Text(item).tag(item)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
