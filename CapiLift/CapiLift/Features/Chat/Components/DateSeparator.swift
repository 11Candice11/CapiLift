//
//  DateSeparator.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct DateSeparator: View {
    let label: String

    var body: some View {
        HStack {
            Spacer()
            Text(label)
                .font(.lcCaption)
                .foregroundStyle(Color.lcMuted)
                .padding(.horizontal, LCSpacing.md)
                .padding(.vertical, LCSpacing.xxs + 2)
                .background(Color.lcBorder.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
            Spacer()
        }
        .padding(.vertical, LCSpacing.sm)
    }
}