//
//  OnboardingRoleStep.swift
//  CapiLift
//

import SwiftUI

struct OnboardingRoleStep: View {
    @Binding var profile: OnboardingProfile

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {

                // ── Title ────────────────────────────────────────────
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("How do you commute?")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                        .multilineTextAlignment(.leading)
                    Text("Choose your role to help us find the best matches for your daily route.")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(3)
                }

                // ── Role cards ───────────────────────────────────────
                VStack(spacing: LCSpacing.sm) {
                    RoleCard(
                        icon: "car.fill",
                        title: "I drive",
                        description: "I have a vehicle and want to offer seats to passengers on my way.",
                        isSelected: profile.role == .driver
                    ) { profile.role = .driver }

                    RoleCard(
                        icon: "mappin.and.ellipse",
                        title: "I need a lift",
                        description: "I prefer to ride with others and share the costs of the commute.",
                        isSelected: profile.role == .passenger
                    ) { profile.role = .passenger }

                    RoleCard(
                        icon: "arrow.2.squarepath",
                        title: "Both",
                        description: "I sometimes drive and sometimes need a lift depending on the day.",
                        isSelected: profile.role == .both,
                        badge: "Flexible"
                    ) { profile.role = .both }
                }
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.bottom, LCSpacing.lg)
        }
    }
}

// MARK: - Role Card

private struct RoleCard: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    var badge: String? = nil
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: LCSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: LCRadius.sm)
                        .fill(Color.lcGreen.opacity(0.1))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(Color.lcGreen)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: LCSpacing.xs) {
                        Text(title)
                            .font(.lcBodyBold)
                            .foregroundStyle(Color.lcGreen)
                        if let badge {
                            Text(badge)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(Color.lcText)
                                .padding(.horizontal, LCSpacing.xs)
                                .padding(.vertical, 2)
                                .background(Color.lcSecondary.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                        }
                    }
                    Text(description)
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(LCSpacing.md)
            .background(Color.lcCard)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: LCRadius.lg)
                    .stroke(isSelected ? Color.lcGreen : Color.lcBorder, lineWidth: isSelected ? 2 : 1)
            }
            .shadow(color: .black.opacity(isSelected ? 0.08 : 0.03), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
