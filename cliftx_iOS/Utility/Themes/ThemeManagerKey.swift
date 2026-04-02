//
//  ThemeManagerKey.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 02/04/26.
//


import SwiftUI

private struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue = ThemeManager()
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}

// Reusable primary button styled with the current theme
public struct PrimaryButton: View {
    @Environment(\.themeManager) private var theme
    let title: String
    let isLoading: Bool
    let action: () -> Void

    public init(_ title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(isLoading ? "Please wait…" : title)
                    .font(.headline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 27)
                    .fill(theme.current.primary)
                    .shadow(color: theme.current.primary.opacity(0.25), radius: 10, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}

public struct AppTextField: View {
    @Environment(\.themeManager) private var theme

    public enum Kind { case plain, secure }

    let kind: Kind
    let systemIcon: String?
    let title: String
    @Binding var text: String
    var focused: FocusState<Bool>.Binding

    public init(_ title: String, text: Binding<String>, kind: Kind = .plain, systemIcon: String? = nil, focused: FocusState<Bool>.Binding) {
        self._text = text
        self.kind = kind
        self.systemIcon = systemIcon
        self.title = title
        self.focused = focused
    }

    public var body: some View {
        HStack(spacing: 16) {
            if let icon = systemIcon {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(focused.wrappedValue ? theme.current.primary : .white.opacity(0.6))
                    .frame(width: 28) // Slightly wider frame to prevent clipping
            }
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(title)
                        .foregroundColor(.white.opacity(0.5))
                        .allowsHitTesting(false)
                }
                
                Group {
                    if kind == .secure {
                        SecureField("", text: $text)
                            .textContentType(.password)
                            .focused(focused)
                    } else {
                        TextField("", text: $text)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .focused(focused)
                    }
                }
                .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(focused.wrappedValue ? theme.current.primary : Color.white.opacity(0.12), lineWidth: 1.75)
                )
        )
        .contentShape(Rectangle())
        .onTapGesture { focused.wrappedValue = true }
    }
}
