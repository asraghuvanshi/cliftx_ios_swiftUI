//
//  EmailVerificationView.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 03/04/26.
//

import SwiftUI

struct EmailVerificationView: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.dismiss) private var dismiss
    
    let email: String
    
    @State private var otpCode = ["", "", "", "", "", ""]
    @State private var isLoading = false
    @State private var timeRemaining = 60
    @State private var canResend = false
    @State private var navigateToCompleteProfile = false
    
    @FocusState private var focusedField: Int?
    
    var isOTPComplete: Bool {
        otpCode.allSatisfy { !$0.isEmpty }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.current.background
                    .ignoresSafeArea()
                
                // Animated gradient orbs
                Circle()
                    .fill(themeManager.current.primary.opacity(0.15))
                    .frame(width: 300, height: 300)
                    .position(x: -50, y: 100)
                    .blur(radius: 60)
                
                Circle()
                    .fill(themeManager.current.accent.opacity(0.12))
                    .frame(width: 250, height: 250)
                    .position(x: UIScreen.main.bounds.width + 50, y: UIScreen.main.bounds.height - 200)
                    .blur(radius: 60)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Animation spacer
                        Spacer(minLength: 60)
                        
                        // Animated envelope icon
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(themeManager.current.primary.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 45))
                                    .foregroundColor(themeManager.current.primary)
                                    .symbolEffect(.bounce, value: true)
                            }
                            
                            Text("Verify Your Email")
                                .font(.title2.bold())
                                .foregroundColor(themeManager.current.textPrimary)
                            
                            Text("We sent a 6-digit code to\n\(email)")
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                                .foregroundColor(themeManager.current.textSecondary)
                        }
                        .padding(.bottom, 20)
                        
                        // OTP Input Fields
                        HStack(spacing: 12) {
                            ForEach(0..<6, id: \.self) { index in
                                OTPTextField(
                                    text: $otpCode[index],
                                    isFocused: focusedField == index
                                )
                                .focused($focusedField, equals: index)
                                .onChange(of: otpCode[index]) { oldValue, newValue in
                                    if newValue.count == 1 && index < 5 {
                                        focusedField = index + 1
                                    } else if newValue.isEmpty && index > 0 {
                                        focusedField = index - 1
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .onAppear {
                            focusedField = 0
                        }
                        
                        // Verify Button
                   
                        PrimaryButton("Verify Email", isLoading: isLoading) { verifyEmail() }
                        .padding(.top, 20)
                        
                        // Resend Section
                        VStack(spacing: 12) {
                            if !canResend {
                                HStack(spacing: 4) {
                                    Text("Resend code in")
                                        .foregroundColor(themeManager.current.textSecondary)
                                    Text("\(timeRemaining)s")
                                        .foregroundColor(themeManager.current.primary)
                                        .fontWeight(.semibold)
                                }
                                .font(.caption)
                            }
                            
                            Button(action: resendCode) {
                                Text(canResend ? "Resend Verification Code" : "Didn't receive code?")
                                    .font(.subheadline)
                                    .foregroundColor(canResend ? themeManager.current.primary : themeManager.current.textSecondary.opacity(0.6))
                            }
                            .disabled(!canResend)
                        }
                        .padding(.top, 10)
                        
                        // Back to login
                        Button(action: { dismiss() }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.caption)
                                Text("Back to Sign In")
                            }
                            .font(.subheadline)
                            .foregroundColor(themeManager.current.textSecondary.opacity(0.6))
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationDestination(isPresented: $navigateToCompleteProfile) {
                CompleteProfileView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func verifyEmail() {
        isLoading = true
        
        let otpString = otpCode.joined()
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            // On success, navigate to complete profile
            navigateToCompleteProfile = true
        }
    }
    
    private func resendCode() {
        guard canResend else { return }
        
        canResend = false
        timeRemaining = 60
        
        // Start timer
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                canResend = true
                timer.invalidate()
            }
        }
        
        // Simulate resend API call
        print("Resending code to \(email)")
    }
}

// MARK: - OTP Text Field Component
struct OTPTextField: View {
    @Binding var text: String
    let isFocused: Bool
    
    var body: some View {
        TextField("", text: $text)
            .frame(width: 52, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .font(.title2.weight(.semibold))
            .foregroundColor(.white)
    }
}
