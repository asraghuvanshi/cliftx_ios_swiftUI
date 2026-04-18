//
//  ProfilePhotoScreen.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 18/04/26.
//


import SwiftUI
import PhotosUI

struct ProfilePhotoScreen: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var navigateToProfessionalInfo = false
    
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
                                
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(themeManager.current.primary)
                                    .scaleEffect(animateFields ? 1 : 0)
                            }
                            
                            Text("Add Profile Photos")
                                .font(.title2.bold())
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("Upload at least one photo to get started")
                                .font(.subheadline)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.bottom, 20)
                        .offset(y: animateFields ? 0 : -30)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Photo Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                            // Photo picker button
                            PhotosPicker(selection: $selectedItems, maxSelectionCount: 6, matching: .images) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(themeManager.current.background)
                                        .frame(height: 120)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(themeManager.current.primary, lineWidth: 0.5)
                                        )
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "plus")
                                            .font(.title2)
                                            .foregroundColor(themeManager.current.primary)
                                        Text("Add Photo")
                                            .font(.caption)
                                            .foregroundColor(themeManager.current.textSecondary)
                                    }
                                }
                            }
                            
                            // Display selected photos
                            ForEach(selectedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    
                                    Button(action: {
                                        selectedImages.remove(at: index)
                                        selectedItems.remove(at: index)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .background(Circle().fill(Color.black.opacity(0.6)))
                                            .font(.title3)
                                    }
                                    .padding(8)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .offset(y: animateFields ? 0 : 30)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Tips
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Photo Tips:")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(themeManager.current.primary)
                                    .font(.caption)
                                Text("Clear, well-lit photos work best")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(themeManager.current.primary)
                                    .font(.caption)
                                Text("Include a photo of you smiling")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(themeManager.current.primary)
                                    .font(.caption)
                                Text("Avoid group photos as your first image")
                                    .font(.caption)
                                    .foregroundColor(themeManager.current.textSecondary)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(themeManager.current.background.opacity(0.5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(themeManager.current.primary, lineWidth: 0.5)
                                )
                        )
                        .padding(.horizontal, 24)
                        
                        // Continue Button
                        PrimaryButton("Continue", isLoading: isLoading) {
                            proceedToNext()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .disabled(selectedImages.isEmpty)
                        .opacity(selectedImages.isEmpty ? 0.6 : 1)
                        
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
            .onChange(of: selectedItems) { _, newItems in
                Task {
                    var newImages: [UIImage] = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            newImages.append(image)
                        }
                    }
                    selectedImages = newImages
                }
            }
            .navigationDestination(isPresented: $navigateToProfessionalInfo) {
                ProfessionalInfoScreen()
            }
        }
    }
    
    private func proceedToNext() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isLoading = false
            navigateToProfessionalInfo = true
        }
    }
}
