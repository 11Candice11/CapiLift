//
//  HomeHeaderView.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct HomeHeaderView: View {
    @Environment(AuthState.self) private var authState

    var body: some View {
        HStack {
            // Avatar
            Circle()
                .fill(Color.lcGreen.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "person.fill")
                        .foregroundStyle(Color.lcGreen)
                        .font(.system(size: 20))
                }

            // Logo
            Text("CapiLift")
                .font(.lcTitle2)
                .foregroundStyle(Color.lcGreen)

            Spacer()

            // Points pill
            HStack(spacing: LCSpacing.xs) {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                    .padding(4)
                    .background(Color.lcGreen)
                    .clipShape(Circle())

                Text("\(authState.currentUser?.totalPoints ?? 0) pts")
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
        .padding(.horizontal, LCSpacing.md)
        .padding(.top, LCSpacing.md)
    }
}
