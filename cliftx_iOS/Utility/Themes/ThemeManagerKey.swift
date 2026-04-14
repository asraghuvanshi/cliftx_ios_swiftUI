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
