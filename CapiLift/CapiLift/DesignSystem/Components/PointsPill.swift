//
//  PointsPill.swift
//  CapiLift
//

import SwiftUI

/// Tappable points pill shown in every screen header.
/// Tapping navigates to the Leaderboard tab (tag 3).
struct PointsPill: View {
    let points: Int
    @Environment(TabSelection.self) private var tabSelection

    var body: some View {
        Button {
            tabSelection.selected = 4
        } label: {
            HStack(spacing: LCSpacing.xs) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcGreen)
                Text("\(points.formatted()) pts")
                    .font(.lcBodyBold)
                    .foregroundStyle(Color.lcText)
            }
            .padding(.horizontal, LCSpacing.sm)
            .padding(.vertical, LCSpacing.xs)
            .background(Color.lcCard)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
            .overlay {
                RoundedRectangle(cornerRadius: LCRadius.pill)
                    .stroke(Color.lcBorder, lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
