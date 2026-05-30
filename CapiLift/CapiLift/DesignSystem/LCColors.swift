//
//  LCColors.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import SwiftUI

extension Color {
    // Brand — LiftClub design system palette
    static let lcGreen      = Color(hex: "2E5BFF")   // Primary — bright blue
    static let lcSecondary  = Color(hex: "F43F5E")   // Secondary — red/pink (CTA)
    static let lcAccent     = Color(hex: "C34100")   // Tertiary — burnt orange
    static let lcCoral      = Color(hex: "C34100")   // Error / destructive

    // Surface
    static let lcBackground = Color(hex: "F1F5F9")   // Clean light neutral
    static let lcCard       = Color.white
    static let lcText       = Color(hex: "1E293B")   // Neutral dark navy
    static let lcMuted      = Color(hex: "64748B")   // Slate grey
    static let lcBorder     = Color(hex: "E2E8F0")   // Light border
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}
