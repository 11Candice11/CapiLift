//
//  LCColors.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import SwiftUI

extension Color {
    static let lcGreen      = Color(hex: "1E7A5C")
    static let lcCoral      = Color(hex: "F26A4B")
    static let lcBackground = Color(hex: "F7F6F2")
    static let lcCard       = Color.white
    static let lcText       = Color(hex: "1C1C1E")
    static let lcMuted      = Color(hex: "8E8E93")
    static let lcBorder     = Color(hex: "E5E5EA")
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
