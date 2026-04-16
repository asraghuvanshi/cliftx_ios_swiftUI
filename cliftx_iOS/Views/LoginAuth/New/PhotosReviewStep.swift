//
//  PhotosReviewStep.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 16/04/26.
//


import SwiftUI
import PhotosUI

struct PhotosReviewStep: View {
    @StateObject private var theme = ThemeManager()
    @Binding var profile: DraftProfile
    
    var onFinish: () -> Void
    var onBack: () -> Void
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Add your photos")
                    .font(.title2.bold())
                    .foregroundColor(theme.current.textPrimary)
                
                PhotoGrid(images: profile.photos)
                
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 6, matching: .images) {
                    Text("Choose Photos").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.horizontal, 24)
                .onChange(of: selectedItems) { _, items in
                    Task {
                        var imgs: [UIImage] = []
                        for item in items {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let img = UIImage(data: data) {
                                imgs.append(img)
                            }
                        }
                        profile.photos = imgs
                    }
                }
                
                Divider().padding(.horizontal, 24)
                
                ReviewCard(profile: profile)
                    .padding(.horizontal, 24)
                
                HStack {
//                    SecondaryButton("Back", action: onBack)
                    Spacer()
                    PrimaryButton("Finish", isLoading: false, action: onFinish)
                        .disabled(profile.photos.count < 3)
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 16)
        }
        .background(theme.current.background.ignoresSafeArea())
    }
}

struct PhotoGrid: View {
    let images: [UIImage]
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(images.indices, id: \.self) { idx in
                Image(uiImage: images[idx])
                    .resizable().scaledToFill()
                    .frame(height: 100).clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            ForEach(images.count..<max(images.count, 6), id: \.self) { _ in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary.opacity(0.12))
                    .frame(height: 100)
                    .overlay(Image(systemName: "plus").font(.title2).foregroundStyle(.secondary))
            }
        }
        .padding(.horizontal, 24)
    }
}

struct ReviewCard: View {
    @StateObject private var theme = ThemeManager()
    let profile: DraftProfile
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Review").font(.headline).foregroundColor(theme.current.textPrimary)
            Group {
                Text("Industry: \(profile.industry)")
                Text("Role: \(profile.role)")
                Text("Experience: \(profile.experienceBucket)")
                Text("Top skills: \(profile.primarySkills.joined(separator: ", "))")
                Text("Preferences: \(profile.preferredSkills.joined(separator: ", "))")
            }
            .font(.subheadline)
            .foregroundColor(theme.current.textSecondary)
        }
        .padding()
        .background(theme.current.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}
