//
//  LCPrimaryButton.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct LCPrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: LCSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .font(.lcBodyBold)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, LCSpacing.md)
            .background(Color.lcGreen)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
        }
        .disabled(isLoading)
    }
}