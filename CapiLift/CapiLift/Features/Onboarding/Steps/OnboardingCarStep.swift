//
//  OnboardingCarStep.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct OnboardingCarStep: View {
    @Binding var profile: OnboardingProfile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {
                // Title
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Your Car")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                    Text("Passengers will use this to identify your car at pickup.")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(4)
                }

                // Car illustration
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.lcGreen.opacity(0.08))
                            .frame(width: 120, height: 120)
                        Image(systemName: "car.fill")
                            .font(.system(size: 52))
                            .foregroundStyle(Color.lcGreen.opacity(0.4))
                    }
                    Spacer()
                }

                // Fields
                VStack(spacing: LCSpacing.md) {
                    HStack(spacing: LCSpacing.sm) {
                        LCTextField(
                            label: "Make",
                            placeholder: "e.g. Toyota",
                            text: $profile.carMake
                        )
                        LCTextField(
                            label: "Model",
                            placeholder: "e.g. Corolla",
                            text: $profile.carModel
                        )
                    }

                    LCTextField(
                        label: "Colour",
                        placeholder: "e.g. Silver",
                        text: $profile.carColour
                    )

                    LCTextField(
                        label: "License Plate",
                        placeholder: "e.g. CA 123-456",
                        text: $profile.licensePlate
                    )
                }

                // Seat selector
                VStack(alignment: .leading, spacing: LCSpacing.sm) {
                    Text("Available Seats")
                        .font(.lcCaptionBold)
                        .foregroundStyle(Color.lcText)
                    Text("How many passengers can you take?")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)

                    HStack(spacing: LCSpacing.sm) {
                        ForEach(1...6, id: \.self) { count in
                            Button {
                                profile.availableSeats = count
                            } label: {
                                VStack(spacing: LCSpacing.xxs) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 16))
                                    Text("\(count)")
                                        .font(.lcCaptionBold)
                                }
                                .foregroundStyle(profile.availableSeats == count ? .white : Color.lcText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, LCSpacing.sm)
                                .background(profile.availableSeats == count ? Color.lcGreen : Color.lcCard)
                                .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                                .overlay {
                                    RoundedRectangle(cornerRadius: LCRadius.md)
                                        .stroke(
                                            profile.availableSeats == count ? Color.clear : Color.lcBorder,
                                            lineWidth: 1
                                        )
                                }
                            }
                        }
                    }
                }

                // Preview card
                if !profile.carMake.isEmpty || !profile.carModel.isEmpty {
                    VStack(alignment: .leading, spacing: LCSpacing.xs) {
                        Text("PREVIEW")
                            .font(.lcCaptionBold)
                            .foregroundStyle(Color.lcMuted)

                        HStack(spacing: LCSpacing.md) {
                            Image(systemName: "car.fill")
                                .foregroundStyle(Color.lcGreen)
                                .font(.system(size: 20))
                                .frame(width: 40, height: 40)
                                .background(Color.lcGreen.opacity(0.1))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text([profile.carMake, profile.carModel, profile.carColour]
                                    .filter { !$0.isEmpty }
                                    .joined(separator: " • "))
                                    .font(.lcBodyBold)
                                    .foregroundStyle(Color.lcText)
                                if !profile.licensePlate.isEmpty {
                                    Text("License: \(profile.licensePlate)")
                                        .font(.lcCaption)
                                        .foregroundStyle(Color.lcMuted)
                                }
                            }

                            Spacer()

                            HStack(spacing: 2) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 11))
                                Text("\(profile.availableSeats) seats")
                                    .font(.lcCaptionBold)
                            }
                            .foregroundStyle(Color.lcGreen)
                            .padding(.horizontal, LCSpacing.xs)
                            .padding(.vertical, LCSpacing.xxs)
                            .background(Color.lcGreen.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                        }
                        .padding(LCSpacing.md)
                        .background(Color.lcCard)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, LCSpacing.md)
        }
    }
}