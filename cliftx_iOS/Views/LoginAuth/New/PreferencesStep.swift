//
//  PreferencesStep.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 16/04/26.
//

import SwiftUI

struct PreferencesStep: View {
    @StateObject private var theme = ThemeManager()
    @Binding var profile: DraftProfile
    
    var onNext: () -> Void
    var onBack: () -> Void
    
    @State private var ageLower: Double = 24
    @State private var ageUpper: Double = 34
    
    let industries = ["Technology","Finance","Consulting","Healthcare","Education","Manufacturing","Media"]
    let skills = ["Swift","Python","Data Analysis","Leadership","Communication","Design"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your preferences")
                    .font(.title2.bold())
                    .foregroundColor(theme.current.textPrimary)
                
          
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Age range").font(.subheadline.bold()).foregroundColor(theme.current.textPrimary)
                    RangeSliderView(lower: $ageLower, upper: $ageUpper, bounds: 18...60)
                    Text("\(Int(ageLower)) - \(Int(ageUpper))")
                        .font(.footnote).foregroundColor(theme.current.textSecondary)
                }
                .onChange(of: ageLower) { _, _ in profile.ageRange = Int(ageLower)...Int(ageUpper) }
                .onChange(of: ageUpper) { _, _ in profile.ageRange = Int(ageLower)...Int(ageUpper) }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Distance (km)").font(.subheadline.bold()).foregroundColor(theme.current.textPrimary)
                    Slider(value: Binding(get: { Double(profile.distanceKm) },
                                          set: { profile.distanceKm = Int($0) }),
                           in: 5...100, step: 5)
                    Text("\(profile.distanceKm) km").font(.footnote).foregroundColor(theme.current.textSecondary)
                }
                
                segmented(title: "Work style", items: ["Remote","Hybrid","In-office"], selection: $profile.workStyle)
                
                HStack {
//                    SecondaryButton("Back", action: onBack)
                    Spacer()
                    PrimaryButton("Continue", isLoading: false, action: onNext)
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
                ForEach(items, id: \.self) { i in Text(i).tag(i) }
            }.pickerStyle(.segmented)
        }
    }
    
  
}
