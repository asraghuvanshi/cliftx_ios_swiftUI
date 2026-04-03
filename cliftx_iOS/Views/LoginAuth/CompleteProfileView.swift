//
//  CompleteProfileView.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 03/04/26.
//

import SwiftUI

struct CompleteProfileView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            themeManager.current.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { step in
                        Rectangle()
                            .fill(step <= currentStep ? themeManager.current.primary : Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .cornerRadius(2)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                TabView(selection: $currentStep) {
                    BasicInfoView()
                        .tag(0)
                    
                    ProfessionalInfoView()
                        .tag(1)
                    
                    ProfilePhotosView()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
}

// MARK: - Step 1: Basic Info
struct BasicInfoView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var fullName = ""
    @State private var dateOfBirth = Date()
    @State private var gender = ""
    @State private var city = ""
    @State private var lookingFor = ""
    
    let genders = ["Male", "Female", "Non-binary", "Prefer not to say"]
    let lookingForOptions = ["Life Partner", "Serious Relationship", "Long-term Dating"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 70))
                        .foregroundColor(themeManager.current.primary)
                    
                    Text("Tell us about yourself")
                        .font(.title2.bold())
                        .foregroundColor(themeManager.current.textPrimary)
                    
                    Text("This helps us find your perfect match")
                        .font(.subheadline)
                        .foregroundColor(themeManager.current.textSecondary)
                }
                .padding(.top, 40)
                
                VStack(spacing: 20) {
                    // Full Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        TextField("", text: $fullName)
                            .textFieldStyle(ModernTextFieldStyle())
                            .placeholder(when: fullName.isEmpty) {
                                Text("Enter your full name").foregroundColor(.gray)
                            }
                    }
                    
                    // Date of Birth
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date of Birth")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                    }
                    
                    // Gender
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gender")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        Picker("", selection: $gender) {
                            Text("Select").tag("")
                            ForEach(genders, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                        .tint(themeManager.current.textPrimary)
                    }
                    
                    // City
                    VStack(alignment: .leading, spacing: 8) {
                        Text("City")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        TextField("", text: $city)
                            .textFieldStyle(ModernTextFieldStyle())
                            .placeholder(when: city.isEmpty) {
                                Text("e.g., Mumbai, Bangalore, Delhi").foregroundColor(.gray)
                            }
                    }
                    
                    // Looking For
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Looking For")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        Picker("", selection: $lookingFor) {
                            Text("Select").tag("")
                            ForEach(lookingForOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                        .tint(themeManager.current.textPrimary)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
            }
        }
        .background(themeManager.current.background)
    }
}

// MARK: - Step 2: Professional Info
struct ProfessionalInfoView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var companyName = ""
    @State private var jobTitle = ""
    @State private var workEmail = ""
    @State private var industry = ""
    @State private var showCompanyOnProfile = true
    @State private var showTitleOnProfile = true
    
    let industries = ["Technology", "Finance", "Healthcare", "Education", "Consulting", "Marketing", "Legal", "Other"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "briefcase.fill")
                        .font(.system(size: 70))
                        .foregroundColor(themeManager.current.primary)
                    
                    Text("Professional Details")
                        .font(.title2.bold())
                        .foregroundColor(themeManager.current.textPrimary)
                    
                    Text("Verify your corporate profile")
                        .font(.subheadline)
                        .foregroundColor(themeManager.current.textSecondary)
                }
                .padding(.top, 40)
                
                VStack(spacing: 20) {
                    // Company Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Company Name")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        TextField("", text: $companyName)
                            .textFieldStyle(ModernTextFieldStyle())
                            .placeholder(when: companyName.isEmpty) {
                                Text("e.g., Google, Microsoft, Infosys").foregroundColor(.gray)
                            }
                    }
                    
                    // Job Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Job Title")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        TextField("", text: $jobTitle)
                            .textFieldStyle(ModernTextFieldStyle())
                            .placeholder(when: jobTitle.isEmpty) {
                                Text("e.g., Senior Software Engineer").foregroundColor(.gray)
                            }
                    }
                    
                    // Work Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Work Email")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        TextField("", text: $workEmail)
                            .textFieldStyle(ModernTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .placeholder(when: workEmail.isEmpty) {
                                Text("name@company.com").foregroundColor(.gray)
                            }
                    }
                    
                    // Industry
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Industry")
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary)
                        Picker("", selection: $industry) {
                            Text("Select").tag("")
                            ForEach(industries, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                        .tint(themeManager.current.textPrimary)
                    }
                    
                    // Privacy Settings
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Privacy Settings")
                            .font(.headline)
                            .foregroundColor(themeManager.current.textPrimary)
                            .padding(.top, 10)
                        
                        Toggle("Show company on profile", isOn: $showCompanyOnProfile)
                            .foregroundColor(themeManager.current.textSecondary)
                        
                        Toggle("Show job title on profile", isOn: $showTitleOnProfile)
                            .foregroundColor(themeManager.current.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
            }
        }
        .background(themeManager.current.background)
    }
}

// MARK: - Step 3: Profile Photos
struct ProfilePhotosView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var selectedPhotos: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var profileSummary = ""
    @State private var showSummary = true
    
    let maxPhotos = 6
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 70))
                        .foregroundColor(themeManager.current.primary)
                    
                    Text("Add Photos")
                        .font(.title2.bold())
                        .foregroundColor(themeManager.current.textPrimary)
                    
                    Text("Upload \(maxPhotos - selectedPhotos.count) more photos")
                        .font(.subheadline)
                        .foregroundColor(themeManager.current.textSecondary)
                }
                .padding(.top, 40)
                
                // Photo Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(0..<maxPhotos, id: \.self) { index in
                        if index < selectedPhotos.count {
                            // Existing photo
                            Image(uiImage: selectedPhotos[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    Button(action: { selectedPhotos.remove(at: index) }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .background(Color.black.opacity(0.6))
                                            .clipShape(Circle())
                                    }
                                    .padding(8),
                                    alignment: .topTrailing
                                )
                        } else {
                            // Add photo button
                            Button(action: { showingImagePicker = true }) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.08))
                                    .frame(height: 120)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .font(.title)
                                            .foregroundColor(themeManager.current.primary)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Profile Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Profile Summary (Optional)")
                        .font(.headline)
                        .foregroundColor(themeManager.current.textPrimary)
                    
                    TextEditor(text: $profileSummary)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                        .foregroundColor(themeManager.current.textPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    
                    Toggle("Show summary on profile", isOn: $showSummary)
                        .foregroundColor(themeManager.current.textSecondary)
                }
                .padding(.horizontal, 24)
                
                // Continue Button
                PrimaryButton("Complete Profile", isLoading: false) {
                    // Save profile and navigate to home
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .background(themeManager.current.background)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImages: $selectedPhotos, maxCount: maxPhotos - selectedPhotos.count)
        }
    }
}

// MARK: - Helper Views
struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)
            .foregroundColor(.white)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    var maxCount: Int
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                if parent.selectedImages.count < parent.maxCount {
                    parent.selectedImages.append(image)
                }
            }
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    CompleteProfileView()
}
