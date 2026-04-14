//
//  SignUpView.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 03/04/26.
//


import SwiftUI

struct SignUpView: View {
    
    @StateObject private var themeManager = ThemeManager()
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var animateFields = false
    @State private var animateButton = false
    @State private var agreeToTerms = false
    @State private var showTermsAlert = false
    
    @FocusState private var isNameFocused: Bool
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    
    
    // Navigation state
    @State private var navigateToVerification = false
    @State private var registeredEmail = ""
    
    var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword &&
        agreeToTerms
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                
                // Theme selector pills
                HStack(spacing: 12) {
                    ForEach(themeManager.themes.indices, id: \.self) { index in
                        Circle()
                            .fill(themeManager.themes[index].primary)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: themeManager.selectedIndex == index ? 3 : 0)
                            )
                            .scaleEffect(themeManager.selectedIndex == index ? 1.1 : 1.0)
                            .onTapGesture { themeManager.selectTheme(at: index) }
                    }
                }
                .padding(.bottom, 20)
                .offset(y: animateFields ? 0 : -30)
                .opacity(animateFields ? 1 : 0)
                
                // Animated logo area
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(themeManager.current.primary.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .scaleEffect(animateFields ? 1 : 0.5)
                            .opacity(animateFields ? 1 : 0)
                        
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 38, weight: .light))
                            .foregroundColor(themeManager.current.primary)
                            .scaleEffect(animateFields ? 1 : 0)
                            .rotationEffect(.degrees(animateFields ? 0 : -90))
                    }
                    
                    Text(UITitle.signUpTitle)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(themeManager.current.textPrimary)
                    
                    Text(UITitle.signUpSubtitle)
                        .font(.subheadline)
                        .foregroundColor(themeManager.current.textSecondary.opacity(0.7))
                }
                .padding(.bottom, 35)
                .offset(y: animateFields ? 0 : -40)
                .opacity(animateFields ? 1 : 0)
                
                // Input fields container
                VStack(spacing: 24) {
                    AppTextField(UIPlaceholderText.fullName, text: $fullName, kind: .plain, systemIcon: "person.fill", focused: $isNameFocused)
                    
                    AppTextField(UIPlaceholderText.email, text: $email, kind: .plain, systemIcon: "envelope.fill", focused: $isEmailFocused)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    AppTextField(UIPlaceholderText.password, text: $password, kind: .secure, systemIcon: "lock.fill", focused: $isPasswordFocused)
                    
                    AppTextField(UIPlaceholderText.confirmPassword, text: $confirmPassword, kind: .secure, systemIcon: "lock.shield.fill", focused: $isConfirmPasswordFocused)
                }
                .padding(.horizontal, 24)
                
                // Password requirements hint
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: password.count >= 6 ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 12))
                            .foregroundColor(password.count >= 6 ? themeManager.current.primary : themeManager.current.textSecondary.opacity(0.4))
                        
                        Text("At least 6 characters")
                            .font(.caption)
                            .foregroundColor(password.count >= 6 ? themeManager.current.primary : themeManager.current.textSecondary.opacity(0.4))
                    }
                    
                    if !password.isEmpty && confirmPassword.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: "circle")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.current.textSecondary.opacity(0.4))
                            
                            Text("Confirm your password")
                                .font(.caption)
                                .foregroundColor(themeManager.current.textSecondary.opacity(0.4))
                        }
                    } else if !confirmPassword.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(password == confirmPassword ? themeManager.current.primary : .red.opacity(0.7))
                            
                            Text(password == confirmPassword ? "Passwords match" : "Passwords don't match")
                                .font(.caption)
                                .foregroundColor(password == confirmPassword ? themeManager.current.primary : .red.opacity(0.7))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                .padding(.top, 8)
                
                // Terms and conditions
                Button(action: {
                    withAnimation(.spring()) {
                        agreeToTerms.toggle()
                    }
                }) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                            .font(.system(size: 18))
                            .foregroundColor(agreeToTerms ? themeManager.current.primary : themeManager.current.textSecondary.opacity(0.5))
                        
                        Text(UITitle.termsAndConditions)
                            .font(.caption)
                            .foregroundColor(themeManager.current.textSecondary.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                .buttonStyle(PlainButtonStyle())
                
                PrimaryButton(UIButtonTitle.signup, isLoading: isLoading) { signUp() }
                    .padding(.horizontal, 24)
                    .padding(.top, 35)
                
                
                Spacer(minLength: 20)
                
                HStack(spacing: 8) {
                    Text(UITitle.alreadyHaveAccount)
                        .foregroundColor(themeManager.current.textSecondary.opacity(0.5))
                        .font(.system(size: 14, weight: .medium))
                    
                    Button(action: {}) {
                        Text(UIButtonTitle.signIn)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(themeManager.current.primary)
                    }
                }
                .padding(.bottom, 30)
                .offset(y: animateButton ? 0 : 80)
                .opacity(animateButton ? 1 : 0)
            }
        }
        .background(
            ZStack {
                themeManager.current.background
                    .ignoresSafeArea()
                
                Circle()
                    .fill(themeManager.current.primary.opacity(0.12))
                    .frame(width: 280, height: 280)
                    .position(x: -50, y: 80)
                    .blur(radius: 60)
                
                Circle()
                    .fill(themeManager.current.accent.opacity(0.1))
                    .frame(width: 250, height: 250)
                    .position(x: UIScreen.main.bounds.width + 30, y: UIScreen.main.bounds.height - 200)
                    .blur(radius: 60)
                
                Circle()
                    .fill(themeManager.current.primary.opacity(0.08))
                    .frame(width: 200, height: 200)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
                    .blur(radius: 50)
            }
        )
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.5)) {
                animateFields = true
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.5).delay(0.3)) {
                animateButton = true
            }
        }
        .alert(isPresented: $showTermsAlert) {
            Alert(
                title: Text(UITitle.termsAlertTitle),
                message: Text(UITitle.termsAlertMessage),
                dismissButton: .default(Text(UIButtonTitle.gotIt))
            )
        }
        // MARK: - Navigation Destination
        .navigationDestination(isPresented: $navigateToVerification) {
            EmailVerificationView(email: registeredEmail)
                .navigationBarBackButtonHidden(true)
        }
        
    }
    
    private func signUp() {
        guard isFormValid else { return }
        
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isLoading = false
                navigateToVerification = true
            }
        }
    }
}

//
//#Preview {
//    SignUpView()
//        .environmentObject(ThemeManager())
//}
