//
//  OnboardingVehicleStep.swift
//  CapiLift
//

import SwiftUI

struct OnboardingVehicleStep: View {
    @Binding var profile: OnboardingProfile

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {

                // ── Hero ─────────────────────────────────────────────
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: [Color(hex: "0D1117"), Color(hex: "1A2035"), Color(hex: "0D1B2A")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    // Faint dashboard silhouette
                    VStack(spacing: 0) {
                        Spacer()
                        RoundedRectangle(cornerRadius: 60)
                            .fill(.white.opacity(0.03))
                            .frame(height: 60)
                            .padding(.horizontal, -40)
                            .blur(radius: 8)
                    }

                    // Large background car icon
                    Image(systemName: "car.fill")
                        .font(.system(size: 160))
                        .foregroundStyle(.white.opacity(0.04))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(x: 20, y: 10)

                    // Text
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your Vehicle")
                            .font(.lcTitle)
                            .foregroundStyle(.white)
                        Text("Help members identify your car")
                            .font(.lcCallout)
                            .foregroundStyle(.white.opacity(0.65))
                    }
                    .padding(LCSpacing.md)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))

                // ── Fields ────────────────────────────────────────────
                VStack(spacing: LCSpacing.md) {
                    VehicleField(label: "Make",          placeholder: "e.g. Tesla",        icon: "car.fill",         text: $profile.carMake)
                    VehicleField(label: "Model",         placeholder: "e.g. Model 3",      icon: "car.rear.fill",    text: $profile.carModel)
                    VehicleField(label: "Color",         placeholder: "e.g. Midnight Blue", icon: "paintpalette",    text: $profile.carColour)
                    VehicleField(label: "License Plate", placeholder: "ABC-1234",           icon: "textformat",       text: $profile.licensePlate,
                                 autocapitalization: .characters)
                }

                // ── Seat selector ──────────────────────────────────────
                VStack(alignment: .leading, spacing: LCSpacing.sm) {
                    HStack(spacing: LCSpacing.sm) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.lcGreen)
                        Text("Available Seats")
                            .font(.lcBodyBold)
                            .foregroundStyle(Color.lcText)

                        Spacer()

                        Text("\(profile.availableSeats) Seats")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, LCSpacing.sm)
                            .padding(.vertical, 4)
                            .background(Color.lcGreen)
                            .clipShape(Capsule())
                    }

                    Text("How many passengers can you comfortably carry?")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(2)

                    HStack(spacing: LCSpacing.sm) {
                        ForEach(1...6, id: \.self) { count in
                            Button { profile.availableSeats = count } label: {
                                Text("\(count)")
                                    .font(.lcBodyBold)
                                    .foregroundStyle(profile.availableSeats == count ? .white : Color.lcText)
                                    .frame(width: 44, height: 44)
                                    .background(profile.availableSeats == count ? Color.lcGreen : Color.lcCard)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .stroke(profile.availableSeats == count ? Color.clear : Color.lcBorder, lineWidth: 1)
                                    }
                            }
                            .buttonStyle(.plain)
                            .animation(.easeInOut(duration: 0.15), value: profile.availableSeats)
                        }
                    }
                }
                .padding(LCSpacing.md)
                .background(Color.lcCard)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.bottom, LCSpacing.lg)
        }
    }
}

// MARK: - Vehicle Field

private struct VehicleField: View {
    let label: String
    let placeholder: String
    let icon: String
    @Binding var text: String
    var autocapitalization: TextInputAutocapitalization = .words

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.xs) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.lcText)

            HStack(spacing: LCSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcMuted.opacity(0.55))
                    .frame(width: 18)

                TextField(placeholder, text: $text)
                    .font(.lcBody)
                    .foregroundStyle(Color.lcText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(autocapitalization)
            }
            .padding(LCSpacing.sm)
            .background(Color.lcCard)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
            .overlay {
                RoundedRectangle(cornerRadius: LCRadius.md)
                    .stroke(Color.lcBorder, lineWidth: 1)
            }
        }
    }
}
