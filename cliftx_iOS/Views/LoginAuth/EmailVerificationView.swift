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
            GeometryReader { geometry in
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
                        .position(x: geometry.size.width + 50, y: geometry.size.height - 200)
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
                            
                            // OTP Input Fields - Fixed spacing
                            HStack(spacing: 12) {
                                ForEach(0..<6, id: \.self) { index in
                                    OTPTextField(
                                        text: $otpCode[index],
                                        isFocused: focusedField == index
                                    )
                                    .focused($focusedField, equals: index)
                                    .onChange(of: otpCode[index]) { _, newValue in
                                        if newValue.count == 1 {
                                            if index < 5 {
                                                focusedField = index + 1
                                            } else {
                                                focusedField = nil
                                            }
                                        } else if newValue.isEmpty, index > 0 {
                                            focusedField = index - 1
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)
                            .onAppear { focusedField = 0 }
                            
                            // Verify Button
                            PrimaryButton("Verify Email", isLoading: isLoading) {
                                verifyEmail()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            
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
                        .padding(.horizontal, 0) // Remove horizontal padding from VStack
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToCompleteProfile) {
                PersonalInfoScreen()
            }
        }
    }
    
    private func verifyEmail() {
        isLoading = true
        
        let _ = otpCode.joined()
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
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

//#Preview {
//    EmailVerificationView(email: "dummyid@gmail.com")
//}
