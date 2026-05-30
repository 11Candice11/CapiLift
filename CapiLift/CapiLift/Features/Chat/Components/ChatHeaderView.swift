//
//  ChatHeaderView.swift
//  CapiLift
//

import SwiftUI

struct ChatHeaderView: View {
    let title: String
    let subtitle: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack(spacing: LCSpacing.sm) {
            // Back
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.lcText)
            }

            // Avatar with online dot
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.lcGreen.opacity(0.12))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.lcGreen.opacity(0.5))
                    }
                Circle()
                    .fill(Color.lcGreen)
                    .frame(width: 11, height: 11)
                    .overlay { Circle().stroke(Color.lcBackground, lineWidth: 2) }
            }

            // Name + subtitle
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.lcBodyBold)
                    .foregroundStyle(Color.lcText)
                Text(subtitle)
                    .font(.lcCaption)
                    .foregroundStyle(Color.lcMuted)
                    .textCase(.uppercase)
                    .tracking(0.4)
            }

            Spacer()

            // More
            Button {
                // options
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.lcText)
            }
        }
        .padding(.horizontal, LCSpacing.md)
        .padding(.vertical, LCSpacing.sm)
        .background(Color.lcCard)
        .overlay(alignment: .bottom) { Divider() }
    }
}
