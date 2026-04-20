//
//  AppTextField.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 14/04/26.
//


import SwiftUI

// MARK: - Custom TextField
struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let icon: String
    var focused: FocusState<Bool>.Binding
    
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isEditing = false
    
    init(_ placeholder: String, text: Binding<String>, isSecure: Bool = false, icon: String, focused: FocusState<Bool>.Binding) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.icon = icon
        self.focused = focused
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(focused.wrappedValue ? themeManager.current.primary : themeManager.current.textSecondary)
                .frame(width: 24)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .textContentType(isSecure ? .password : .emailAddress)
            .autocapitalization(isSecure ? .none : .allCharacters)
            .disableAutocorrection(true)
            .foregroundColor(themeManager.current.textPrimary)
            .focused(focused)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.current.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            focused.wrappedValue ? themeManager.current.primary.opacity(0.5) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: themeManager.current.primary.opacity(focused.wrappedValue ? 0.2 : 0), radius: 8)
    }
}
