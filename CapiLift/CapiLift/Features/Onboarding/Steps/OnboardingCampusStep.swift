//
//  OnboardingCampusStep.swift
//  CapiLift
//

import SwiftUI

struct OnboardingCampusStep: View {
    @Binding var profile: OnboardingProfile

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {

                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Which office do\nyou go to?")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                    Text("Select your primary campus to find matches and schedules relevant to your commute.")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(3)
                }

                // Full-width stacked campus cards
                VStack(spacing: LCSpacing.md) {
                    ForEach(User.Campus.allCases, id: \.self) { campus in
                        CampusCard(campus: campus, isSelected: profile.campus == campus) {
                            profile.campus = campus
                        }
                    }
                }

                Text("MODERN COMMUTING. REDEFINED.")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color.lcMuted)
                    .tracking(1.5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, LCSpacing.md)
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.bottom, LCSpacing.lg)
        }
    }
}

// MARK: - Campus Card

private struct CampusCard: View {
    let campus: User.Campus
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: LCRadius.lg)
                    .fill(LinearGradient(
                        colors: [Color.lcGreen.opacity(0.85), Color.lcGreen],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(height: 160)
                    .overlay {
                        Image(systemName: campus == .stellenbosch ? "building.columns" : "building.2")
                            .font(.system(size: 80, weight: .ultraLight))
                            .foregroundStyle(Color.white.opacity(0.2))
                    }

                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 28, height: 3)
                    Text(campus.displayName)
                        .font(.lcTitle3)
                        .foregroundStyle(Color.white)
                }
                .padding(LCSpacing.md)
            }
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: LCRadius.lg)
                    .stroke(isSelected ? Color.lcSecondary : Color.clear, lineWidth: 3)
            }
            .shadow(color: .black.opacity(isSelected ? 0.12 : 0.06), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
