//
//  LCFonts.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//
//  Matches "Radical Simplicity" design system:
//  Headlines → bold/semibold geometric sans (Hanken Grotesk → SF Pro)
//  Body/Label → regular/medium sans (Inter → SF Pro)

import SwiftUI

extension Font {
    static let lcLargeTitle  = Font.system(size: 34, weight: .bold,     design: .default)
    static let lcTitle       = Font.system(size: 28, weight: .bold,     design: .default)
    static let lcTitle2      = Font.system(size: 22, weight: .semibold, design: .default)
    static let lcTitle3      = Font.system(size: 18, weight: .semibold, design: .default)
    static let lcBody        = Font.system(size: 16, weight: .regular,  design: .default)
    static let lcBodyBold    = Font.system(size: 16, weight: .semibold, design: .default)
    static let lcCallout     = Font.system(size: 15, weight: .regular,  design: .default)
    static let lcCaption     = Font.system(size: 12, weight: .regular,  design: .default)
    static let lcCaptionBold = Font.system(size: 12, weight: .semibold, design: .default)
}
