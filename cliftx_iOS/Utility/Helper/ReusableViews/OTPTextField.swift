//
//  OTPTextField 2.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 19/04/26.
//


import SwiftUI

// MARK: - OTP Text Field
struct OTPTextField: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var text: String
    let isFocused: Bool
    let index: Int
    let totalFields: Int
    
    @State private var isAnimating = false
    
    init(text: Binding<String>, isFocused: Bool, index: Int = 0, totalFields: Int = 6) {
        self._text = text
        self.isFocused = isFocused
        self.index = index
        self.totalFields = totalFields
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.current.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isFocused ? themeManager.current.primary : Color.clear,
                            lineWidth: 2
                        )
                )
                .shadow(
                    color: isFocused ? themeManager.current.primary.opacity(0.3) : Color.clear,
                    radius: isAnimating ? 12 : 0,
                    y: isAnimating ? 0 : 0
                )
            
            if isFocused {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: themeManager.current.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .opacity(isAnimating ? 1 : 0)
            }
            
            // Text field
            TextField("", text: $text)
                .frame(width: 52, height: 62)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(themeManager.current.textPrimary)
                .tint(themeManager.current.primary)
                .background(Color.clear)
                .onChange(of: text) { _, newValue in
                    // Allow only single digit
                    if newValue.count > 1 {
                        text = String(newValue.suffix(1))
                    }
                    if !newValue.isEmpty && !newValue.allSatisfy({ $0.isNumber }) {
                        text = ""
                    }
                }
        }
        .frame(width: 52, height: 62)
        .scaleEffect(isFocused && isAnimating ? 1.05 : 1.0)
        .onAppear {
            if isFocused {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6).repeatCount(1)) {
                    isAnimating = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }
        }
        .onChange(of: isFocused) { _, newValue in
            if newValue {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    isAnimating = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }
        }
    }
}
