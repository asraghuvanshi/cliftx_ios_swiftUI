//
//  Chip.swift
//  cliftx_iOS
//
//  Created by iOS Developer on 16/04/26.
//

import SwiftUI

struct Chip: View {
    @StateObject private var theme = ThemeManager()
    let text: String
    var isSelected: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(isSelected ? theme.current.primary.opacity(0.15) : Color.secondary.opacity(0.12))
                .foregroundStyle(isSelected ? theme.current.primary : theme.current.textPrimary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct RangeSliderView: View {
    @Binding var lower: Double
    @Binding var upper: Double
    let bounds: ClosedRange<Double>
    
    var body: some View {
        VStack {
            Slider(value: $lower, in: bounds, step: 1)
            Slider(value: $upper, in: bounds, step: 1)
        }
    }
}
