//
//  OTPTextField.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 14/04/26.
//

import SwiftUI

// MARK: - OTP Text Field Component
struct OTPTextField: View {
    @Environment(\.themeManager) private var theme
    @Binding var text: String
    let isFocused: Bool

    var body: some View {
        TextField("", text: $text)
            .frame(width: 50, height: 58)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme.current.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isFocused
                        ? theme.current.primary
                        : theme.current.surface.opacity(0.4),
                        lineWidth: 1.5
                    )
            )
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .font(.title3.weight(.semibold))
            .foregroundColor(theme.current.textPrimary)
            .tint(theme.current.primary)
            .onChange(of: text) { _, newValue in
                if newValue.count > 1 {
                    text = String(newValue.last!)
                }
            }
    }
}
