//
//  SignUpView.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 03/04/26.
//


import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    // Form fields
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var animateButton = false
    @State private var agreeToTerms = false
    @State private var showTermsAlert = false
    
    // Focus states
    @FocusState private var isNameFocused: Bool
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    
    // Navigation
    @State private var navigateToVerification = false
    @State private var registeredEmail = ""
    
    // Password strength
    @State private var passwordStrength: PasswordStrength = .none
    
    // Password strength enum
    enum PasswordStrength {
        case none, weak, medium, strong
        
        var color: Color {
            switch self {
            case .none: return .gray.opacity(0.3)
            case .weak: return .red
            case .medium: return .orange
            case .strong: return .green
            }
        }
        
        var text: String {
            switch self {
            case .none: return ""
            case .weak: return "Weak"
            case .medium: return "Medium"
            case .strong: return "Strong"
            }
        }
    }
    
    var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        isValidEmail(email) &&
        passwordStrength != .weak &&
        passwordStrength != .none &&
        password == confirmPassword &&
        agreeToTerms
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                themeManager.current.background
                    .ignoresSafeArea()
                
                ForEach(0..<3) { i in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    themeManager.current.primary.opacity(colorScheme == .dark ? 0.25 : 0.15),
                                    themeManager.current.accent.opacity(colorScheme == .dark ? 0.12 : 0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: CGFloat(300 + i * 50))
                        .position(
                            x: i == 0 ? -50 : (i == 1 ? UIScreen.main.bounds.width + 50 : UIScreen.main.bounds.width / 2),
                            y: i == 0 ? 100 : (i == 1 ? UIScreen.main.bounds.height - 200 : UIScreen.main.bounds.height / 3)
                        )
                        .blur(radius: colorScheme == .dark ? 70 : 50)
                        .opacity(animateFields ? 0.8 : 0)
                        .animation(.easeInOut(duration: 1.5).delay(Double(i) * 0.3), value: animateFields)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 40)
                        
                        // Logo Area (matching LoginView style)
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: themeManager.current.gradientColors,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .opacity(0.15)
                                    .scaleEffect(animateFields ? 1 : 0.5)
                                
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 36, weight: .light))
                                    .foregroundColor(themeManager.current.primary)
                                    .scaleEffect(animateFields ? 1 : 0)
                                    .rotationEffect(.degrees(animateFields ? 0 : -90))
                            }
                            
                            Text("Create Account")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("Sign up to get started")
                                .font(.subheadline)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.bottom, 48)
                        .offset(y: animateFields ? 0 : -40)
                        .opacity(animateFields ? 1 : 0)
                        
                        // Input Fields (using same AppTextField as LoginView)
                        VStack(spacing: 20) {
                            AppTextField("Full Name", text: $fullName, icon: "person.fill", focused: $isNameFocused)
                            
                            AppTextField("Email", text: $email, icon: "envelope.fill", focused: $isEmailFocused)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                AppTextField("Password", text: $password, isSecure: true, icon: "lock.fill", focused: $isPasswordFocused)
                                
                                // Password strength indicator
                                if !password.isEmpty {
                                    HStack {
                                        Text("Password Strength:")
                                            .font(.caption2)
                                            .foregroundColor(themeManager.current.textSecondary.opacity(0.6))
                                        
                                        Text(passwordStrength.text)
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(passwordStrength.color)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 4)
                                    
                                    // Strength bar
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(themeManager.current.surface)
                                                .frame(height: 3)
                                                .cornerRadius(1.5)
                                            
                                            Rectangle()
                                                .fill(passwordStrength.color)
                                                .frame(width: geometry.size.width * strengthProgress(), height: 3)
                                                .cornerRadius(1.5)
                                                .animation(.spring(), value: passwordStrength)
                                        }
                                    }
                                    .frame(height: 3)
                                    .padding(.horizontal, 4)
                                }
                            }
                            
                            AppTextField("Confirm Password", text: $confirmPassword, isSecure: true, icon: "lock.shield.fill", focused: $isConfirmPasswordFocused)
                        }
                        .padding(.horizontal, 24)
                        
                        // Password match hint
                        if !confirmPassword.isEmpty && !password.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(password == confirmPassword ? themeManager.current.primary : .red.opacity(0.7))
                                
                                Text(password == confirmPassword ? "Passwords match" : "Passwords don't match")
                                    .font(.caption2)
                                    .foregroundColor(password == confirmPassword ? themeManager.current.primary : .red.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 32)
                            .padding(.top, 4)
                        }
                        
                        // Terms and conditions (matching LoginView style)
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                agreeToTerms.toggle()
                            }
                        }) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 18))
                                    .foregroundColor(agreeToTerms ? themeManager.current.primary : themeManager.current.textSecondary.opacity(0.5))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("I agree to the")
                                        .font(.caption)
                                        .foregroundColor(themeManager.current.textSecondary.opacity(0.7))
                                    
                                    HStack(spacing: 4) {
                                        Text("Terms of Service")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(themeManager.current.primary)
                                        
                                        Text("and")
                                            .font(.caption)
                                            .foregroundColor(themeManager.current.textSecondary.opacity(0.7))
                                        
                                        Text("Privacy Policy")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(themeManager.current.primary)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Sign Up Button (same as LoginView)
                        PrimaryButton("Sign Up", isLoading: isLoading) { signUp() }
                            .padding(.horizontal, 24)
                            .padding(.top, 32)
                            .disabled(!isFormValid)
                            .opacity(isFormValid ? 1 : 0.6)
                        
                        Spacer(minLength: 40)
                        
                        HStack(spacing: 8) {
                            Text("Already have an account?")
                                .foregroundColor(themeManager.current.textSecondary.opacity(0.6))
                                .font(.system(size: 14, weight: .medium))
                            
                            Button(action: { dismiss() }) {
                                Text("Sign In")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(themeManager.current.primary)
                            }
                        }
                        .padding(.bottom, 30)
                        .offset(y: animateButton ? 0 : 80)
                        .opacity(animateButton ? 1 : 0)
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.5)) {
                    animateFields = true
                }
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.5).delay(0.3)) {
                    animateButton = true
                }
            }
            .onChange(of: password) { _, newValue in
                updatePasswordStrength(newValue)
            }
            .navigationDestination(isPresented: $navigateToVerification) {
                OTPVerificationView(
                    email: registeredEmail,
                    onVerificationSuccess: {
                        print("Verification successful!")
                    }
                )
                .navigationBarBackButtonHidden(true)
                .environmentObject(themeManager)
            }
            .alert("Terms & Conditions", isPresented: $showTermsAlert) {
                Button("Got it", role: .cancel) { }
            } message: {
                Text("Please read and accept our terms and conditions to continue.")
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(themeManager.current.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func updatePasswordStrength(_ password: String) {
        if password.isEmpty {
            passwordStrength = .none
            return
        }
        
        var strength = 0
        
        // Length check
        if password.count >= 8 { strength += 2 }
        else if password.count >= 6 { strength += 1 }
        
        // Contains number
        if password.contains(where: { $0.isNumber }) { strength += 1 }
        
        // Contains uppercase
        if password.contains(where: { $0.isUppercase }) { strength += 1 }
        
        // Contains special character
        let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")
        if password.rangeOfCharacter(from: specialCharacters) != nil { strength += 1 }
        
        switch strength {
        case 0...1:
            passwordStrength = .weak
        case 2...3:
            passwordStrength = .medium
        default:
            passwordStrength = .strong
        }
    }
    
    private func strengthProgress() -> CGFloat {
        switch passwordStrength {
        case .none: return 0
        case .weak: return 0.33
        case .medium: return 0.66
        case .strong: return 1.0
        }
    }
    
    private func signUp() {
        guard isFormValid else { return }
        
        isLoading = true
        registeredEmail = email
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isLoading = false
                navigateToVerification = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SignUpView()
        .environmentObject(ThemeManager())
}
