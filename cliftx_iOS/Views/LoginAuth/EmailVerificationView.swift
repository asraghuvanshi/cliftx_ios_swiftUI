//
//  EmailVerificationView.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 03/04/26.
//

import SwiftUI
import Combine

// MARK: - Complete OTP View
struct OTPVerificationView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var otpCode = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @State private var isLoading = false
    @State private var timerCount = 30
    @State private var canResend = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isVerified = false
    
    let email: String
    let onVerificationSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
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
                    
                    Image(systemName: "message.badge.fill")
                        .font(.system(size: 36))
                        .foregroundColor(themeManager.current.primary)
                }
                
                Text("Verification Code")
                    .font(.title2.weight(.bold))
                    .foregroundColor(themeManager.current.textPrimary)
                
                Text("Enter the 6-digit code sent to\n\(email)")
                    .font(.subheadline)
                    .foregroundColor(themeManager.current.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            // OTP Fields
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    OTPTextField(
                        text: $otpCode[index],
                        isFocused: focusedField == index,
                        index: index,
                        totalFields: 6
                    )
                    .onChange(of: otpCode[index]) { _, newValue in
                        if !newValue.isEmpty {
                            // Move to next field
                            if index < 5 {
                                focusedField = index + 1
                            } else {
                                // Auto-submit when all fields filled
                                if !otpCode.contains("") {
                                    verifyOTP()
                                }
                            }
                        } else if newValue.isEmpty && index > 0 {
                            // Move to previous field on delete
                            focusedField = index - 1
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .onAppear {
                focusedField = 0
            }
            
            // Verify Button
            PrimaryButton("Verify", isLoading: isLoading) {
                verifyOTP()
            }
            .padding(.horizontal, 24)
            .disabled(otpCode.contains("") || isLoading)
            .opacity(otpCode.contains("") ? 0.6 : 1)
            
            // Resend Section
            VStack(spacing: 12) {
                if !canResend {
                    HStack(spacing: 4) {
                        Text("Resend code in")
                            .font(.caption)
                            .foregroundColor(themeManager.current.textSecondary)
                        
                        Text("\(timerCount)s")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(themeManager.current.primary)
                            .contentTransition(.numericText())
                    }
                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                        if timerCount > 0 && !canResend {
                            timerCount -= 1
                        } else if timerCount == 0 {
                            canResend = true
                        }
                    }
                } else {
                    Button(action: resendCode) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.clockwise")
                                .font(.caption)
                            Text("Resend Code")
                                .font(.subheadline.weight(.medium))
                        }
                        .foregroundColor(themeManager.current.primary)
                    }
                }
            }
            .padding(.top, 20)
            
            // Edit Email Link
            Button(action: {
                // Navigate back to edit email
            }) {
                Text("Wrong email? Edit")
                    .font(.caption)
                    .foregroundColor(themeManager.current.textSecondary.opacity(0.7))
            }
            
            Spacer(minLength: 40)
        }
        .background(themeManager.current.background)
        .alert("Verification Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .navigationDestination(isPresented: $isVerified) {
            // Navigate to next screen
            Text("Verification Successful!")
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        onVerificationSuccess()
                    }
                }
        }
    }
    
    private func verifyOTP() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            // Demo verification - in real app, verify with backend
            let enteredCode = otpCode.joined()
            if enteredCode == "123456" {
                isVerified = true
            } else {
                errorMessage = "Invalid verification code. Please try again."
                showError = true
                
                // Clear OTP fields on error
                otpCode = Array(repeating: "", count: 6)
                focusedField = 0
            }
        }
    }
    
    private func resendCode() {
        timerCount = 30
        canResend = false
        
        // Simulate resend API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Show success message
            errorMessage = "New verification code sent to \(email)"
            showError = true
        }
    }
}

// MARK: - Alternative: OTPField (Simpler Version)
struct SimpleOTPField: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var code: String
    let fieldCount: Int
    
    @FocusState private var focusedIndex: Int?
    @State private var otpValues: [String]
    
    init(code: Binding<String>, fieldCount: Int = 6) {
        self._code = code
        self.fieldCount = fieldCount
        self._otpValues = State(initialValue: Array(repeating: "", count: fieldCount))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<fieldCount, id: \.self) { index in
                TextField("", text: $otpValues[index])
                    .frame(width: 50, height: 58)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(themeManager.current.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                focusedIndex == index ? themeManager.current.primary : themeManager.current.surface.opacity(0.4),
                                lineWidth: 1.5
                            )
                    )
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(themeManager.current.textPrimary)
                    .tint(themeManager.current.primary)
                    .focused($focusedIndex, equals: index)
                    .onChange(of: otpValues[index]) { _, newValue in
                        // Limit to single character
                        if newValue.count > 1 {
                            otpValues[index] = String(newValue.suffix(1))
                        }
                        // Only allow digits
                        if !newValue.isEmpty && !newValue.allSatisfy({ $0.isNumber }) {
                            otpValues[index] = ""
                        }
                        
                        // Auto-advance to next field
                        if !otpValues[index].isEmpty && index < fieldCount - 1 {
                            focusedIndex = index + 1
                        }
                        // Auto-submit on last field
                        else if !otpValues[index].isEmpty && index == fieldCount - 1 {
                            // Handle auto-submit
                            code = otpValues.joined()
                        }
                        
                        // Update binding
                        code = otpValues.joined()
                    }
                    .onSubmit {
                        if index < fieldCount - 1 {
                            focusedIndex = index + 1
                        }
                    }
            }
        }
        .onAppear {
            focusedIndex = 0
        }
    }
}
