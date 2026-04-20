//
//  ThemeManagerKey.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 02/04/26.
//


import SwiftUI
import Combine

// MARK: - AppTheme Model
public struct AppTheme: Identifiable, Equatable {
    public let id = UUID()
    public let name: String
    public let primary: Color
    public let accent: Color
    public let background: Color
    public let surface: Color
    public let textPrimary: Color
    public let textSecondary: Color
    public let gradientColors: [Color]
    
    public static func == (lhs: AppTheme, rhs: AppTheme) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Enhanced Theme Manager
public final class ThemeManager: ObservableObject {
    
    @Published public var themes: [AppTheme]
    @Published public var selectedIndex: Int = 0
    
    public var current: AppTheme {
        themes[selectedIndex]
    }
    
    public init() {
        self.themes = [
            AppTheme(
                name: "Midnight Nebula",
                primary: ThemeColors.midnightPrimary,
                accent: ThemeColors.midnightAccent,
                background: ThemeColors.background,
                surface: ThemeColors.surface,
                textPrimary: ThemeColors.textPrimary,
                textSecondary: ThemeColors.textSecondary,
                gradientColors: [ThemeColors.midnightPrimary, ThemeColors.midnightAccent]
            ),
            AppTheme(
                name: "Ocean Depths",
                primary: ThemeColors.oceanPrimary,
                accent: ThemeColors.oceanAccent,
                background: ThemeColors.background,
                surface: ThemeColors.surface,
                textPrimary: ThemeColors.textPrimary,
                textSecondary: ThemeColors.textSecondary,
                gradientColors: [ThemeColors.oceanPrimary, ThemeColors.oceanAccent]
            ),
            AppTheme(
                name: "Cyber Punk",
                primary: ThemeColors.cyberPrimary,
                accent: ThemeColors.cyberAccent,
                background: ThemeColors.background,
                surface: ThemeColors.surface,
                textPrimary: ThemeColors.textPrimary,
                textSecondary: ThemeColors.textSecondary,
                gradientColors: [ThemeColors.cyberPrimary, ThemeColors.cyberAccent]
            ),
            AppTheme(
                name: "Emerald Forest",
                primary: ThemeColors.emeraldPrimary,
                accent: ThemeColors.emeraldAccent,
                background: ThemeColors.background,
                surface: ThemeColors.surface,
                textPrimary: ThemeColors.textPrimary,
                textSecondary: ThemeColors.textSecondary,
                gradientColors: [ThemeColors.emeraldPrimary, ThemeColors.emeraldAccent]
            ),
            AppTheme(
                name: "Sunset Blaze",
                primary: ThemeColors.sunsetPrimary,
                accent: ThemeColors.sunsetAccent,
                background: ThemeColors.background,
                surface: ThemeColors.surface,
                textPrimary: ThemeColors.textPrimary,
                textSecondary: ThemeColors.textSecondary,
                gradientColors: [ThemeColors.sunsetPrimary, ThemeColors.sunsetAccent]
            ),
            AppTheme(
                name: "Royal Purple",
                primary: ThemeColors.royalPrimary,
                accent: ThemeColors.royalAccent,
                background: ThemeColors.background,
                surface: ThemeColors.surface,
                textPrimary: ThemeColors.textPrimary,
                textSecondary: ThemeColors.textSecondary,
                gradientColors: [ThemeColors.royalPrimary, ThemeColors.royalAccent]
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
