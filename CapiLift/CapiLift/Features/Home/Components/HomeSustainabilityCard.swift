//
//  HomeSustainabilityCard.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct HomeSustainabilityCard: View {
    // Mock — will be calculated from completed rides
    let co2Saved: Double = 12.4

    var body: some View {
        HStack(spacing: LCSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color.lcGreen.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: "leaf.fill")
                    .foregroundStyle(Color.lcGreen)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Sustainability Impact")
                    .font(.lcCaption)
                    .foregroundStyle(Color.lcMuted)
                Text("\(co2Saved, specifier: "%.1f")kg CO2 Saved")
                    .font(.lcTitle3)
                    .foregroundStyle(Color.lcText)
            }

            Spacer()
        }
        .padding(LCSpacing.md)
        .background(Color.lcGreen.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
        .padding(.horizontal, LCSpacing.md)
    }
}