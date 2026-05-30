//
//  RewardsView.swift
//  CapiLift
//

import SwiftUI

// MARK: - Models

private struct RewardItem: Identifiable {
    let id = UUID()
    let title: String
    let pointsCost: Int
    let isAvailable: Bool
    let icon: String
}

private struct PartnerBenefit: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let iconColor: Color
    let icon: String
}

private let mockRewards: [RewardItem] = [
    RewardItem(title: "LiftClub Premium Tee",  pointsCost: 350,  isAvailable: true,  icon: "tshirt.fill"),
    RewardItem(title: "Eco-Hydrate Bottle",    pointsCost: 200,  isAvailable: true,  icon: "drop.fill"),
    RewardItem(title: "Hi-Fi Noise Cancel",    pointsCost: 800,  isAvailable: false, icon: "headphones"),
    RewardItem(title: "Urban Commuter Pack",   pointsCost: 1200, isAvailable: false, icon: "bag.fill"),
]

private let mockPartners: [PartnerBenefit] = [
    PartnerBenefit(title: "Monday Bean Co.",     subtitle: "20% off all Americanos",            iconColor: Color(hex: "E03C31"), icon: "cup.and.saucer.fill"),
    PartnerBenefit(title: "Premium Parking Pass", subtitle: "24/7 access to partner bays",      iconColor: Color.lcGreen,        icon: "parkingsign.circle.fill"),
]

// MARK: - View

struct RewardsView: View {
    @Environment(AuthState.self) private var authState
    @Environment(\.dismiss) private var dismiss
    @State private var redeemedId: UUID? = nil

    var totalPoints: Int { authState.currentUser?.totalPoints ?? 520 }

    var body: some View {
        ZStack {
            Color.lcBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Header ────────────────────────────────────────
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.lcText)
                        }

                        Spacer()

                        Text("Redeem Your Progress")
                            .font(.lcBodyBold)
                            .foregroundStyle(Color.lcText)

                        Spacer()

                        Circle()
                            .fill(Color.lcGreen.opacity(0.12))
                            .frame(width: 36, height: 36)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color.lcGreen)
                            }
                    }
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.top, LCSpacing.md)
                    .padding(.bottom, LCSpacing.md)

                    // ── Balance Card ──────────────────────────────────
                    VStack(spacing: LCSpacing.xs) {
                        Text("TOTAL BALANCE")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.7))
                            .tracking(1.2)

                        HStack(alignment: .center, spacing: LCSpacing.sm) {
                            Text("\(totalPoints)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(.white)

                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.15))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "star.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                            }
                        }

                        Text("Points earned from 12 safe trips")
                            .font(.lcCaption)
                            .foregroundStyle(.white.opacity(0.75))
                            .padding(.top, 2)

                        Text("All points valid until Silver Member")
                            .font(.lcCaption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LCSpacing.lg)
                    .padding(.horizontal, LCSpacing.md)
                    .background(Color.lcGreen)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.bottom, LCSpacing.lg)

                    // ── Available Items ───────────────────────────────
                    HStack {
                        Text("Available Items")
                            .font(.lcTitle3)
                            .foregroundStyle(Color.lcText)
                        Spacer()
                        Button { } label: {
                            Text("Show All")
                                .font(.lcCaption)
                                .foregroundStyle(Color.lcGreen)
                        }
                    }
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.bottom, LCSpacing.sm)

                    // ── Reward Cards ──────────────────────────────────
                    VStack(spacing: LCSpacing.md) {
                        ForEach(mockRewards) { reward in
                            RewardCard(
                                reward: reward,
                                userPoints: totalPoints,
                                isRedeemed: redeemedId == reward.id
                            ) {
                                withAnimation { redeemedId = reward.id }
                            }
                        }
                    }
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.bottom, LCSpacing.xl)

                    // ── Partner Benefits ──────────────────────────────
                    VStack(alignment: .leading, spacing: LCSpacing.sm) {
                        Text("Partner Benefits")
                            .font(.lcTitle3)
                            .foregroundStyle(Color.lcText)
                            .padding(.horizontal, LCSpacing.md)

                        VStack(spacing: 0) {
                            ForEach(Array(mockPartners.enumerated()), id: \.element.id) { i, partner in
                                PartnerRow(partner: partner)
                                if i < mockPartners.count - 1 {
                                    Divider()
                                        .padding(.leading, 68)
                                }
                            }
                        }
                        .background(Color.lcCard)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                        .overlay {
                            RoundedRectangle(cornerRadius: LCRadius.lg)
                                .stroke(Color.lcBorder, lineWidth: 1)
                        }
                        .padding(.horizontal, LCSpacing.md)
                    }
                    .padding(.bottom, LCSpacing.xxl)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Reward Card

private struct RewardCard: View {
    let reward: RewardItem
    let userPoints: Int
    let isRedeemed: Bool
    let onRedeem: () -> Void

    var canAfford: Bool { userPoints >= reward.pointsCost }

    var body: some View {
        VStack(spacing: 0) {
            // Product image area
            ZStack {
                Color(hex: "F0F0EE")
                    .frame(height: 180)

                if !reward.isAvailable {
                    Color.black.opacity(0.08)
                }

                Image(systemName: reward.icon)
                    .font(.system(size: 72, weight: .thin))
                    .foregroundStyle(reward.isAvailable ? Color.lcText.opacity(0.55) : Color.lcMuted.opacity(0.3))

                if !reward.isAvailable {
                    VStack(spacing: LCSpacing.xs) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.lcMuted)
                        Text("Need \(reward.pointsCost - userPoints) more pts")
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }
                }
            }
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: LCRadius.lg,
                topTrailingRadius: LCRadius.lg
            ))

            // Info + button
            VStack(alignment: .leading, spacing: LCSpacing.sm) {
                Text(reward.title)
                    .font(.lcBodyBold)
                    .foregroundStyle(reward.isAvailable ? Color.lcText : Color.lcMuted)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.lcSecondary)
                    Text("@ \(reward.pointsCost) Points")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.lcMuted)
                }

                Button {
                    guard reward.isAvailable && canAfford else { return }
                    onRedeem()
                } label: {
                    Text(isRedeemed ? "✓ Redeemed!" : "Redeem Now")
                        .font(.lcBodyBold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.sm + 2)
                        .background(
                            isRedeemed        ? Color.lcGreen.opacity(0.55) :
                            (reward.isAvailable && canAfford) ? Color.lcGreen : Color.lcMuted.opacity(0.35)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                }
                .disabled(!reward.isAvailable || !canAfford || isRedeemed)
            }
            .padding(LCSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.lcCard)
            .clipShape(UnevenRoundedRectangle(
                bottomLeadingRadius: LCRadius.lg,
                bottomTrailingRadius: LCRadius.lg
            ))
        }
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Partner Row

private struct PartnerRow: View {
    let partner: PartnerBenefit

    var body: some View {
        HStack(spacing: LCSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: LCRadius.sm)
                    .fill(partner.iconColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: partner.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(partner.iconColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(partner.title)
                    .font(.lcBodyBold)
                    .foregroundStyle(Color.lcText)
                Text(partner.subtitle)
                    .font(.lcCaption)
                    .foregroundStyle(Color.lcMuted)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.lcMuted)
        }
        .padding(.horizontal, LCSpacing.md)
        .padding(.vertical, LCSpacing.sm + 2)
    }
}
