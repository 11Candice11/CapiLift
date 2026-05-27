//
//  LCFonts.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import SwiftUI

extension Font {
    static let lcLargeTitle  = Font.system(.largeTitle,  design: .rounded, weight: .bold)
    static let lcTitle       = Font.system(.title,       design: .rounded, weight: .bold)
    static let lcTitle2      = Font.system(.title2,      design: .rounded, weight: .semibold)
    static let lcTitle3      = Font.system(.title3,      design: .rounded, weight: .semibold)
    static let lcBody        = Font.system(.body,        weight: .regular)
    static let lcBodyBold    = Font.system(.body,        weight: .semibold)
    static let lcCallout     = Font.system(.callout,     weight: .regular)
    static let lcCaption     = Font.system(.caption,     weight: .regular)
    static let lcCaptionBold = Font.system(.caption,     weight: .semibold)
}
