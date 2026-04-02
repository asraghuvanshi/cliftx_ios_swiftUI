//
//  ThemeColors.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 02/04/26.
//


import SwiftUI
import Combine

// Centralized color definitions that the app can reuse
public enum ThemeColors {
    // Base palette (customize freely)
    public static let oceanPrimary = Color(red: 0.4, green: 0.6, blue: 0.9)
    public static let oceanAccent  = Color(red: 0.5, green: 0.7, blue: 1.0)

    public static let purplePrimary = Color(red: 0.6, green: 0.4, blue: 0.9)
    public static let purpleAccent  = Color(red: 0.7, green: 0.5, blue: 1.0)

    public static let mintPrimary = Color(red: 0.2, green: 0.8, blue: 0.6)
    public static let mintAccent  = Color(red: 0.3, green: 0.9, blue: 0.7)

    public static let sunsetPrimary = Color(red: 0.9, green: 0.5, blue: 0.3)
    public static let sunsetAccent  = Color(red: 1.0, green: 0.6, blue: 0.4)

    public static let rosePrimary = Color(red: 0.8, green: 0.3, blue: 0.5)
    public static let roseAccent  = Color(red: 0.9, green: 0.4, blue: 0.6)

    // Common semantic colors
    public static let backgroundDark = Color(red: 0.08, green: 0.08, blue: 0.12)
    public static let surfaceDark = Color(red: 0.12, green: 0.12, blue: 0.16)
    public static let textPrimaryOnDark = Color.white
    public static let textSecondaryOnDark = Color.white.opacity(0.7)
}

// Theme model
public struct AppTheme: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let primary: Color
    public let accent: Color
    public let background: Color
    public let surface: Color
    public let textPrimary: Color
    public let textSecondary: Color

    public init(id: String, name: String, primary: Color, accent: Color, background: Color, surface: Color, textPrimary: Color, textSecondary: Color) {
        self.id = id
        self.name = name
        self.primary = primary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
    }
}

// Manager to provide and switch themes app-wide
public final class ThemeManager: ObservableObject {
    @Published public var themes: [AppTheme]
    @Published public var selectedIndex: Int

    public var current: AppTheme { themes[selectedIndex] }

    public init() {
        self.themes = [
            AppTheme(id: "ocean", name: "Ocean Blue", primary: ThemeColors.oceanPrimary, accent: ThemeColors.oceanAccent, background: ThemeColors.backgroundDark, surface: ThemeColors.surfaceDark, textPrimary: ThemeColors.textPrimaryOnDark, textSecondary: ThemeColors.textSecondaryOnDark),
            AppTheme(id: "purple", name: "Purple Dream", primary: ThemeColors.purplePrimary, accent: ThemeColors.purpleAccent, background: ThemeColors.backgroundDark, surface: ThemeColors.surfaceDark, textPrimary: ThemeColors.textPrimaryOnDark, textSecondary: ThemeColors.textSecondaryOnDark),
            AppTheme(id: "mint", name: "Mint Fresh", primary: ThemeColors.mintPrimary, accent: ThemeColors.mintAccent, background: ThemeColors.backgroundDark, surface: ThemeColors.surfaceDark, textPrimary: ThemeColors.textPrimaryOnDark, textSecondary: ThemeColors.textSecondaryOnDark),
            AppTheme(id: "sunset", name: "Sunset Orange", primary: ThemeColors.sunsetPrimary, accent: ThemeColors.sunsetAccent, background: ThemeColors.backgroundDark, surface: ThemeColors.surfaceDark, textPrimary: ThemeColors.textPrimaryOnDark, textSecondary: ThemeColors.textSecondaryOnDark),
            AppTheme(id: "rose", name: "Rose Pink", primary: ThemeColors.rosePrimary, accent: ThemeColors.roseAccent, background: ThemeColors.backgroundDark, surface: ThemeColors.surfaceDark, textPrimary: ThemeColors.textPrimaryOnDark, textSecondary: ThemeColors.textSecondaryOnDark)
        ]
        self.selectedIndex = 0
    }

    public func selectTheme(at index: Int) {
        guard themes.indices.contains(index) else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            selectedIndex = index
        }
    }
}
