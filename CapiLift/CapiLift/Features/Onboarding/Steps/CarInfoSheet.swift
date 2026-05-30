//
//  CarInfoSheet.swift
//  CapiLift
//

import SwiftUI

struct CarInfoSheet: View {
    @Binding var profile: OnboardingProfile
    @Environment(\.dismiss) private var dismiss

    @State private var make:   String = ""
    @State private var model:  String = ""
    @State private var colour: String = ""
    @State private var plate:  String = ""
    @State private var seats:  Int    = 4

    @State private var makeTouched:   Bool = false
    @State private var modelTouched:  Bool = false
    @State private var colourTouched: Bool = false
    @State private var plateTouched:  Bool = false

    var makeError:   String? { makeTouched   && make.trimmingCharacters(in: .whitespaces).isEmpty   ? "Required" : nil }
    var modelError:  String? { modelTouched  && model.trimmingCharacters(in: .whitespaces).isEmpty  ? "Required" : nil }
    var colourError: String? { colourTouched && colour.trimmingCharacters(in: .whitespaces).isEmpty ? "Required" : nil }
    var plateError:  String? { plateTouched  && plate.trimmingCharacters(in: .whitespaces).isEmpty  ? "Required" : nil }

    var isValid: Bool {
        !make.trimmingCharacters(in: .whitespaces).isEmpty &&
        !model.trimmingCharacters(in: .whitespaces).isEmpty &&
        !colour.trimmingCharacters(in: .whitespaces).isEmpty &&
        !plate.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: LCSpacing.lg) {

                    // ── Hero ─────────────────────────────────────────
                    ZStack {
                        LinearGradient(
                            colors: [Color.lcText, Color.lcGreen.opacity(0.8)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                        Image(systemName: "car.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.white.opacity(0.12))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))

                    // ── Title ────────────────────────────────────────
                    VStack(alignment: .leading, spacing: LCSpacing.xs) {
                        Text("Tell us about your car")
                            .font(.lcTitle)
                            .foregroundStyle(Color.lcText)
                        Text("Your vehicle details help passengers find you and ensure a comfortable ride for everyone.")
                            .font(.lcCallout)
                            .foregroundStyle(Color.lcMuted)
                            .lineSpacing(3)
                    }

                    // ── Fields ───────────────────────────────────────
                    HStack(spacing: LCSpacing.md) {
                        ValidatedField(label: "Make",  placeholder: "e.g. Tesla",   text: $make,  error: makeError)  { makeTouched  = true }
                        ValidatedField(label: "Model", placeholder: "e.g. Model 3", text: $model, error: modelError) { modelTouched = true }
                    }

                    HStack(spacing: LCSpacing.md) {
                        ValidatedField(label: "Colour",        placeholder: "e.g. Midnight Blue", text: $colour, error: colourError) { colourTouched = true }
                        ValidatedField(label: "License Plate", placeholder: "ABC-1234",            text: $plate,  error: plateError)  { plateTouched  = true }
                    }

                    // ── Seat selector ────────────────────────────────
                    VStack(alignment: .leading, spacing: LCSpacing.sm) {
                        Text("Available Seats for Passengers")
                            .font(.lcCaptionBold)
                            .foregroundStyle(Color.lcText)

                        HStack(spacing: LCSpacing.sm) {
                            ForEach(1...6, id: \.self) { count in
                                Button { seats = count } label: {
                                    Text("\(count)")
                                        .font(.lcBodyBold)
                                        .foregroundStyle(seats == count ? .white : Color.lcText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, LCSpacing.sm)
                                        .background(seats == count ? Color.lcGreen : Color.lcCard)
                                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: LCRadius.md)
                                                .stroke(seats == count ? Color.clear : Color.lcBorder, lineWidth: 1)
                                        }
                                }
                            }
                        }

                        Text("Excluding the driver's seat.")
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }
                }
                .padding(LCSpacing.md)
            }
            .background(Color.lcBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.lcMuted)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    makeTouched = true; modelTouched = true
                    colourTouched = true; plateTouched = true
                    guard isValid else { return }
                    profile.carMake        = make
                    profile.carModel       = model
                    profile.carColour      = colour
                    profile.licensePlate   = plate
                    profile.availableSeats = seats
                    dismiss()
                } label: {
                    HStack(spacing: LCSpacing.xs) {
                        Text("Save Car")
                            .font(.lcBodyBold)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LCSpacing.md)
                    .background(isValid ? Color.lcSecondary : Color.lcSecondary.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                }
                .padding(.horizontal, LCSpacing.md)
                .padding(.bottom, LCSpacing.lg)
                .background(Color.lcBackground)
                .animation(.easeInOut(duration: 0.2), value: isValid)
            }
        }
        .onAppear {
            make   = profile.carMake
            model  = profile.carModel
            colour = profile.carColour
            plate  = profile.licensePlate
            seats  = profile.availableSeats > 0 ? profile.availableSeats : 4
        }
    }
}
