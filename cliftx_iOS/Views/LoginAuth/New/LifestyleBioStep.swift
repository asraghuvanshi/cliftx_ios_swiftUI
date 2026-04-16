//
//  LifestyleBioStep.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 16/04/26.
//

import SwiftUI

struct LifestyleBioStep: View {
    @StateObject private var theme = ThemeManager()
    @Binding var profile: DraftProfile
    
    var onNext: () -> Void
    var onBack: () -> Void
    
    let interestsAll = ["Reading","Running","Travel","Cooking","Music","Fitness","Gaming","Photography"]
    let languagesAll = ["English","Hindi","Kannada","Tamil","Telugu"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("A bit more about you")
                    .font(.title2.bold())
                    .foregroundColor(theme.current.textPrimary)
                
            
                VStack(alignment: .leading, spacing: 8) {
                    Text("Short bio")
                        .font(.subheadline.bold())
                        .foregroundColor(theme.current.textPrimary)
                    TextField("Keep it warm and concise (200 chars)", text: $profile.bio, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3, reservesSpace: true)
                    Text("\(profile.bio.count)/200")
                        .font(.footnote).foregroundColor(theme.current.textSecondary)
                }
                
                HStack {
//                    SecondaryButton("Back", action: onBack)
                    Spacer()
                    PrimaryButton("Continue", isLoading: false, action: onNext)
                }
            }
            .padding(24)
        }
        .background(theme.current.background.ignoresSafeArea())
        .onChange(of: profile.bio) { _, new in
            if new.count > 200 { profile.bio = String(new.prefix(200)) }
        }
    }
}
