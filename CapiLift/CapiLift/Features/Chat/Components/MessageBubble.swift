//
//  MessageBubble.swift
//  CapiLift
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    let currentUserId: UUID
    var showSenderName: Bool = false

    private var isFromCurrentUser: Bool { message.sender.id == currentUserId }

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        return f.string(from: message.sentAt)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: LCSpacing.xs) {
            if isFromCurrentUser {
                Spacer(minLength: 56)
                outgoingBubble
            } else {
                // Avatar for incoming
                Circle()
                    .fill(Color.lcGreen.opacity(0.12))
                    .frame(width: 32, height: 32)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.lcGreen.opacity(0.5))
                    }
                incomingBubble
                Spacer(minLength: 56)
            }
        }
        .padding(.vertical, 3)
        .padding(.horizontal, LCSpacing.sm)
    }

    // MARK: - Outgoing (right, primary blue)

    private var outgoingBubble: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(message.content)
                .font(.lcBody)
                .foregroundStyle(.white)
                .padding(.horizontal, LCSpacing.md)
                .padding(.vertical, LCSpacing.sm)
                .background(Color.lcGreen)
                .clipShape(RoundedRectangle(cornerRadius: 18))

            HStack(spacing: 4) {
                if message.isRead {
                    Text("READ")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(Color.lcMuted)
                        .tracking(0.5)
                }
                Text(timeString)
                    .font(.system(size: 10))
                    .foregroundStyle(Color.lcMuted)
                if message.isRead {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.lcGreen)
                }
            }
        }
    }

    // MARK: - Incoming (left, light blue-grey)

    private var incomingBubble: some View {
        VStack(alignment: .leading, spacing: 4) {
            if showSenderName {
                Text(message.sender.fullName)
                    .font(.lcCaptionBold)
                    .foregroundStyle(Color.lcGreen)
            }

            Text(message.content)
                .font(.lcBody)
                .foregroundStyle(Color.lcText)
                .padding(.horizontal, LCSpacing.md)
                .padding(.vertical, LCSpacing.sm)
                .background(Color.lcCard)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)

            Text(timeString)
                .font(.system(size: 10))
                .foregroundStyle(Color.lcMuted)
        }
    }
}
