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

// MARK: - Enhanced Theme Colors
public enum ThemeColors {
    
    // MARK: - Theme 1: Midnight Nebula (Premium Dark)
    public static let midnightPrimary = Color.dynamic(
        light: UIColor(red: 0.45, green: 0.35, blue: 0.95, alpha: 1),
        dark:  UIColor(red: 0.55, green: 0.45, blue: 1.00, alpha: 1)
    )
    
    public static let midnightAccent = Color.dynamic(
        light: UIColor(red: 0.35, green: 0.25, blue: 0.85, alpha: 1),
        dark:  UIColor(red: 0.70, green: 0.60, blue: 1.00, alpha: 1)
    )
    
    // MARK: - Theme 2: Ocean Depths
    public static let oceanPrimary = Color.dynamic(
        light: UIColor(red: 0.05, green: 0.55, blue: 0.85, alpha: 1),
        dark:  UIColor(red: 0.10, green: 0.70, blue: 1.00, alpha: 1)
    )
    
    public static let oceanAccent = Color.dynamic(
        light: UIColor(red: 0.00, green: 0.45, blue: 0.75, alpha: 1),
        dark:  UIColor(red: 0.30, green: 0.80, blue: 1.00, alpha: 1)
    )
    
    // MARK: - Theme 3: Cyber Punk
    public static let cyberPrimary = Color.dynamic(
        light: UIColor(red: 0.90, green: 0.20, blue: 0.60, alpha: 1),
        dark:  UIColor(red: 1.00, green: 0.30, blue: 0.70, alpha: 1)
    )
    
    public static let cyberAccent = Color.dynamic(
        light: UIColor(red: 0.80, green: 0.15, blue: 0.50, alpha: 1),
        dark:  UIColor(red: 1.00, green: 0.45, blue: 0.80, alpha: 1)
    )
    
    // MARK: - Theme 4: Emerald Forest
    public static let emeraldPrimary = Color.dynamic(
        light: UIColor(red: 0.10, green: 0.70, blue: 0.40, alpha: 1),
        dark:  UIColor(red: 0.20, green: 0.85, blue: 0.50, alpha: 1)
    )
    
    public static let emeraldAccent = Color.dynamic(
        light: UIColor(red: 0.05, green: 0.60, blue: 0.35, alpha: 1),
        dark:  UIColor(red: 0.40, green: 0.95, blue: 0.65, alpha: 1)
    )
    
    // MARK: - Theme 5: Sunset Blaze
    public static let sunsetPrimary = Color.dynamic(
        light: UIColor(red: 0.95, green: 0.45, blue: 0.20, alpha: 1),
        dark:  UIColor(red: 1.00, green: 0.55, blue: 0.30, alpha: 1)
    )
    
    public static let sunsetAccent = Color.dynamic(
        light: UIColor(red: 0.85, green: 0.35, blue: 0.10, alpha: 1),
        dark:  UIColor(red: 1.00, green: 0.70, blue: 0.45, alpha: 1)
    )
    
    // MARK: - Theme 6: Royal Purple
    public static let royalPrimary = Color.dynamic(
        light: UIColor(red: 0.60, green: 0.20, blue: 0.85, alpha: 1),
        dark:  UIColor(red: 0.75, green: 0.35, blue: 1.00, alpha: 1)
    )
    
    public static let royalAccent = Color.dynamic(
        light: UIColor(red: 0.50, green: 0.10, blue: 0.75, alpha: 1),
        dark:  UIColor(red: 0.85, green: 0.50, blue: 1.00, alpha: 1)
    )
    
    // MARK: - Backgrounds (Enhanced Dark Mode)
    public static let background = Color.dynamic(
        light: UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1),
        dark:  UIColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 1)
    )
    
    public static let surface = Color.dynamic(
        light: UIColor.white,
        dark:  UIColor(red: 0.08, green: 0.10, blue: 0.14, alpha: 1)
    )
    
    public static let surfaceElevated = Color.dynamic(
        light: UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1),
        dark:  UIColor(red: 0.12, green: 0.14, blue: 0.18, alpha: 1)
    )
    
    // MARK: - Text Colors
    public static let textPrimary = Color.dynamic(
        light: UIColor.black,
        dark:  UIColor.white
    )
    
    public static let textSecondary = Color.dynamic(
        light: UIColor.darkGray,
        dark:  UIColor.white.withAlphaComponent(0.7)
    )
    
    public static let textTertiary = Color.dynamic(
        light: UIColor.gray,
        dark:  UIColor.white.withAlphaComponent(0.5)
    )
}
