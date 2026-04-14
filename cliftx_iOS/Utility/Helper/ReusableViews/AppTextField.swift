//
//  AppTextField.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 14/04/26.
//


import SwiftUI

public struct AppTextField: View {
    @Environment(\.themeManager) private var theme

    public enum Kind { case plain, secure }

    let kind: Kind
    let systemIcon: String?
    let title: String
    @Binding var text: String
    var focused: FocusState<Bool>.Binding

    public init(
        _ title: String,
        text: Binding<String>,
        kind: Kind = .plain,
        systemIcon: String? = nil,
        focused: FocusState<Bool>.Binding
    ) {
        self._text = text
        self.kind = kind
        self.systemIcon = systemIcon
        self.title = title
        self.focused = focused
    }

    public var body: some View {
        HStack(spacing: 14) {

            if let icon = systemIcon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        focused.wrappedValue
                        ? theme.current.primary
                        : theme.current.textSecondary
                    )
                    .frame(width: 26)
            }

            Group {
                if kind == .secure {
                    SecureField(title, text: $text)
                        .textContentType(.password)
                        .focused(focused)
                } else {
                    TextField(title, text: $text)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .focused(focused)
                }
            }
            .foregroundColor(theme.current.textPrimary)
            .tint(theme.current.primary) // cursor color
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.current.surface.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    focused.wrappedValue
                    ? theme.current.primary
                    : theme.current.surface.opacity(0.4),
                    lineWidth: 1.5
                )
        )
        .animation(.easeOut(duration: 0.2), value: focused.wrappedValue)
    }
}
