//
//  CO2Banner.swift
//  CapiLift
//

import SwiftUI

struct CO2Banner: View {
    let co2Saved: Double

    var body: some View {
        HStack(spacing: LCSpacing.xs) {
            Text("🌿")
                .font(.system(size: 15))
            Text("This ride saves \(co2Saved, specifier: "%.1f")kg CO2")
                .font(.lcBodyBold)
                .foregroundStyle(Color.lcText)
        }
        .padding(.horizontal, LCSpacing.lg)
        .padding(.vertical, LCSpacing.sm + 2)
        .background(Color.lcSecondary.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
    }
}
