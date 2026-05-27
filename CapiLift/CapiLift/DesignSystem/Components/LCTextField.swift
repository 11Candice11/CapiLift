//
//  LCTextField.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct LCTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.xs) {
            Text(label)
                .font(.lcCaptionBold)
                .foregroundStyle(Color.lcText)
            TextField(placeholder, text: $text)
                .font(.lcBody)
                .keyboardType(keyboardType)
                .autocorrectionDisabled()
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
                .padding(LCSpacing.sm)
                .background(Color.lcBackground)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                .overlay {
                    RoundedRectangle(cornerRadius: LCRadius.md)
                        .stroke(Color.lcBorder, lineWidth: 1)
                }
        }
    }
}