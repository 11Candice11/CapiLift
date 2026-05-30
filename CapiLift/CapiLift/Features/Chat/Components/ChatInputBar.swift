//
//  ChatInputBar.swift
//  CapiLift
//

import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    @FocusState private var isFocused: Bool

    private var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        HStack(spacing: LCSpacing.sm) {
            // Plus / attachment
            Button {
                // attachments
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.lcBorder.opacity(0.6))
                        .frame(width: 36, height: 36)
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.lcMuted)
                }
            }

            // Text field
            TextField("Send a message...", text: $text, axis: .vertical)
                .font(.lcBody)
                .foregroundStyle(Color.lcText)
                .lineLimit(1...5)
                .focused($isFocused)
                .padding(.horizontal, LCSpacing.md)
                .padding(.vertical, LCSpacing.xs + 2)
                .background(Color.lcBackground)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))

            // Mic (empty) or Send (has text) — always visible
            if isEmpty {
                Button {
                    // voice input
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.lcBorder.opacity(0.6))
                            .frame(width: 36, height: 36)
                        Image(systemName: "mic.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.lcMuted)
                    }
                }
            } else {
                Button(action: onSend) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.lcGreen)
                            .frame(width: 44, height: 40)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding(.horizontal, LCSpacing.md)
        .padding(.vertical, LCSpacing.sm)
        .background(Color.lcCard)
        .overlay(alignment: .top) { Divider() }
        .animation(.easeInOut(duration: 0.15), value: isEmpty)
    }
}
