//
//  ThemeColors.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 02/04/26.
//


import SwiftUI
import Combine


extension Color {
    static func dynamic(
        light: UIColor,
        dark: UIColor
    ) -> Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        })
    }
}

public enum ThemeColors {

    // MARK: - Apple Indigo (Primary Premium Color)
    public static let primary = Color.dynamic(
        light: UIColor(red: 0.30, green: 0.40, blue: 0.95, alpha: 1),
        dark:  UIColor(red: 0.45, green: 0.55, blue: 1.00, alpha: 1)
    )

    public static let accent = Color.dynamic(
        light: UIColor(red: 0.20, green: 0.30, blue: 0.85, alpha: 1),
        dark:  UIColor(red: 0.60, green: 0.70, blue: 1.00, alpha: 1)
    )

    // MARK: - Backgrounds (Apple Standard)
    public static let background = Color.dynamic(
        light: UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1),
        dark:  UIColor(red: 0.05, green: 0.06, blue: 0.10, alpha: 1)
    )

    public static let surface = Color.dynamic(
        light: UIColor.white,
        dark:  UIColor(red: 0.10, green: 0.12, blue: 0.16, alpha: 1)
    )

    // MARK: - Text
    public static let textPrimary = Color.dynamic(
        light: UIColor.black,
        dark:  UIColor.white
    )

    public static let textSecondary = Color.dynamic(
        light: UIColor.darkGray,
        dark:  UIColor.white.withAlphaComponent(0.7)
    )
}

public struct AppTheme: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let primary: Color
    public let accent: Color
    public let background: Color
    public let surface: Color
    public let textPrimary: Color
    public let textSecondary: Color
}


public final class ThemeManager: ObservableObject {

    @Published public var themes: [AppTheme]
    @Published public var selectedIndex: Int = 0

    public var current: AppTheme {
        themes[selectedIndex]
    }

    public init() {
        self.themes = [
            AppTheme(
                id: "applePremium",
                name: "Apple Premium",
                primary: ThemeColors.primary,
                accent: ThemeColors.accent,
                background: ThemeColors.background,
                surface: ThemeColors.surface,
                textPrimary: ThemeColors.textPrimary,
                textSecondary: ThemeColors.textSecondary
            )
        ]
    }

    public func selectTheme(at index: Int) {
        guard themes.indices.contains(index) else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            selectedIndex = index
        }
    }
}
