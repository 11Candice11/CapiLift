//
//  DriveReviewSheet.swift
//  CapiLift
//

import SwiftUI

struct DriveReviewSheet: View {
    let driverFirstName: String
    var onSubmit: (Int, String) -> Void
    var onReport: () -> Void
    var onDismiss: () -> Void

    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.lcBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // ── Header ───────────────────────────────────────────
                HStack {
                    HStack(spacing: LCSpacing.xs) {
                        Image(systemName: "car.2.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.lcGreen)
                        Text("CapiLift")
                            .font(.lcBodyBold)
                            .foregroundStyle(Color.lcText)
                    }
                    Spacer()
                    Button {
                        onDismiss()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.lcMuted)
                            .frame(width: 32, height: 32)
                            .background(Color.lcBorder.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, LCSpacing.md)
                .padding(.top, LCSpacing.md)
                .padding(.bottom, LCSpacing.lg)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: LCSpacing.lg) {

                        // ── Avatar ───────────────────────────────────
                        Circle()
                            .fill(Color.lcGreen.opacity(0.12))
                            .frame(width: 88, height: 88)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.lcGreen.opacity(0.5))
                            }
                            .overlay {
                                Circle()
                                    .stroke(Color.lcCard, lineWidth: 3)
                            }
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)

                        // ── Title ────────────────────────────────────
                        Text("How was your trip with \(driverFirstName)?")
                            .font(.lcTitle2)
                            .foregroundStyle(Color.lcText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, LCSpacing.lg)

                        // ── Star rating ──────────────────────────────
                        VStack(spacing: LCSpacing.xs) {
                            HStack(spacing: LCSpacing.sm) {
                                ForEach(1...5, id: \.self) { star in
                                    Button {
                                        withAnimation(.spring(response: 0.3)) {
                                            rating = star
                                        }
                                    } label: {
                                        Image(systemName: star <= rating ? "star.fill" : "star")
                                            .font(.system(size: 32))
                                            .foregroundStyle(star <= rating ? Color.lcSecondary : Color.lcBorder)
                                            .scaleEffect(star <= rating ? 1.1 : 1.0)
                                            .animation(.spring(response: 0.2), value: rating)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }

                            Text(rating == 0 ? "Tap to rate" : ratingLabel)
                                .font(.lcCaption)
                                .foregroundStyle(Color.lcMuted)
                                .animation(.easeInOut, value: rating)
                        }

                        // ── Review text ──────────────────────────────
                        VStack(alignment: .leading, spacing: LCSpacing.xs) {
                            Text("Add a public review...")
                                .font(.lcBodyBold)
                                .foregroundStyle(Color.lcText)

                            ZStack(alignment: .topLeading) {
                                if reviewText.isEmpty {
                                    Text("Share details of your experience (e.g. communication, punctuality)...")
                                        .font(.lcBody)
                                        .foregroundStyle(Color.lcMuted)
                                        .padding(.horizontal, LCSpacing.sm)
                                        .padding(.vertical, LCSpacing.sm + 2)
                                }
                                TextEditor(text: $reviewText)
                                    .font(.lcBody)
                                    .foregroundStyle(Color.lcText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, LCSpacing.xs)
                                    .padding(.vertical, LCSpacing.xs)
                                    .frame(minHeight: 110)
                            }
                            .background(Color.lcCard)
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                            .overlay {
                                RoundedRectangle(cornerRadius: LCRadius.md)
                                    .stroke(Color.lcBorder, lineWidth: 1)
                            }
                        }

                        // ── Submit ───────────────────────────────────
                        Button {
                            onSubmit(rating, reviewText)
                            dismiss()
                        } label: {
                            Text("Submit Review")
                                .font(.lcBodyBold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, LCSpacing.md)
                                .background(rating > 0 ? Color.lcGreen : Color.lcGreen.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                        }
                        .disabled(rating == 0)
                        .animation(.easeInOut(duration: 0.2), value: rating)

                        // ── Report link ──────────────────────────────
                        Button {
                            onReport()
                            dismiss()
                        } label: {
                            Text("Report an issue with this driver")
                                .font(.lcBodyBold)
                                .foregroundStyle(Color.lcGreen)
                        }
                        .padding(.bottom, LCSpacing.xl)
                    }
                    .padding(.horizontal, LCSpacing.md)
                }
            }
        }
    }

    private var ratingLabel: String {
        switch rating {
        case 1: return "Poor"
        case 2: return "Fair"
        case 3: return "Good"
        case 4: return "Great"
        case 5: return "Excellent!"
        default: return ""
        }
    }
}
