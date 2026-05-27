//
//  OnboardingCampusStep.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct OnboardingCampusStep: View {
    @Binding var profile: OnboardingProfile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Your Campus")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                    Text("Which office is your primary campus?")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                }

                // Campus cards
                HStack(spacing: LCSpacing.md) {
                    ForEach(User.Campus.allCases, id: \.self) { campus in
                        CampusCard(
                            campus: campus,
                            isSelected: profile.campus == campus
                        ) {
                            profile.campus = campus
                        }
                    }
                }

                // Role section
                VStack(alignment: .leading, spacing: LCSpacing.sm) {
                    Text("I want to be a...")
                        .font(.lcTitle3)
                        .foregroundStyle(Color.lcText)

                    HStack(spacing: LCSpacing.sm) {
                        RolePill(
                            title: "Driver",
                            icon: "car.fill",
                            isSelected: profile.role == .driver
                        ) { profile.role = .driver }

                        RolePill(
                            title: "Passenger",
                            icon: "person.fill",
                            isSelected: profile.role == .passenger
                        ) { profile.role = .passenger }

                        RolePill(
                            title: "Both",
                            icon: "arrow.2.squarepath",
                            isSelected: profile.role == .both
                        ) { profile.role = .both }
                    }
                }
            }
            .padding(.horizontal, LCSpacing.md)
        }
    }
}

private struct CampusCard: View {
    let campus: User.Campus
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: LCSpacing.sm) {
                RoundedRectangle(cornerRadius: LCRadius.md)
                    .fill(Color.lcGreen.opacity(0.1))
                    .frame(height: 90)
                    .overlay {
                        Image(systemName: campus == .stellenbosch ? "building.columns.fill" : "building.2.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(Color.lcGreen.opacity(0.6))
                    }
                Text(campus.displayName)
                    .font(.lcBodyBold)
                    .foregroundStyle(Color.lcText)
            }
            .padding(LCSpacing.sm)
            .frame(maxWidth: .infinity)
            .background(Color.lcCard)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: LCRadius.lg)
                    .stroke(isSelected ? Color.lcGreen : Color.lcBorder, lineWidth: isSelected ? 2 : 1)
            }
            .shadow(color: .black.opacity(isSelected ? 0.1 : 0.04), radius: 8, x: 0, y: 2)
        }
    }
}

private struct RolePill: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: LCSpacing.xxs) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                Text(title)
                    .font(.lcCaptionBold)
            }
            .foregroundStyle(isSelected ? .white : Color.lcText)
            .padding(.horizontal, LCSpacing.sm)
            .padding(.vertical, LCSpacing.xs)
            .background(isSelected ? Color.lcGreen : Color.lcCard)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
            .overlay {
                RoundedRectangle(cornerRadius: LCRadius.pill)
                    .stroke(isSelected ? Color.clear : Color.lcBorder, lineWidth: 1)
            }
        }
    }
}
