//
//  OnboardingProfileStep.swift
//  CapiLift
//

import SwiftUI

struct OnboardingProfileStep: View {
    @Binding var profile: OnboardingProfile
    @State private var nameTouched = false

    var nameError: String? {
        guard nameTouched else { return nil }
        let parts = profile.fullName.trimmingCharacters(in: .whitespaces).split(separator: " ")
        if profile.fullName.trimmingCharacters(in: .whitespaces).isEmpty { return "Name is required" }
        if parts.count < 2 { return "Please enter your first and last name" }
        return nil
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: LCSpacing.xl) {

                // ── Title ────────────────────────────────────────────
                VStack(spacing: LCSpacing.sm) {
                    Text("What's your name?")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                        .multilineTextAlignment(.center)
                    Text("Enter your legal name as it appears on your ID. This helps us maintain a secure carpooling community for everyone.")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(3)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, LCSpacing.lg)

                // ── Name field ───────────────────────────────────────
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("FULL NAME")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.lcMuted)
                        .tracking(1.0)

                    TextField("e.g. Alexander Pierce", text: $profile.fullName)
                        .font(.lcBody)
                        .foregroundStyle(Color.lcText)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                        .padding(LCSpacing.md)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                        .overlay {
                            RoundedRectangle(cornerRadius: LCRadius.md)
                                .stroke(nameError != nil ? Color.lcCoral : Color.lcBorder, lineWidth: 1)
                        }
                        .onChange(of: profile.fullName) { _, _ in nameTouched = true }

                    if let error = nameError {
                        Text(error)
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcCoral)
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: nameError)

                // ── Security note ────────────────────────────────────
                HStack(alignment: .center, spacing: LCSpacing.sm) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.lcGreen)
                    Text("Your name will only be visible to your matched drivers or passengers after a ride is confirmed.")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcText)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, LCSpacing.md)
                .padding(.vertical, LCSpacing.md)
                .background(Color.white.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                .overlay {
                    RoundedRectangle(cornerRadius: LCRadius.pill)
                        .stroke(Color.lcBorder, lineWidth: 1)
                }
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.bottom, LCSpacing.lg)
        }
    }
}

// MARK: - Reusable validated field (kept for other steps)

struct ValidatedField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let error: String?
    var keyboardType: UIKeyboardType = .default
    var onEditingChanged: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.xs) {
            Text(label.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.lcMuted)
                .tracking(0.8)

            TextField(placeholder, text: $text)
                .font(.lcBody)
                .keyboardType(keyboardType)
                .autocorrectionDisabled()
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
                .padding(LCSpacing.sm)
                .background(Color.lcBackground)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                .overlay {
                    RoundedRectangle(cornerRadius: LCRadius.md)
                        .stroke(error != nil ? Color.lcCoral : Color.lcBorder, lineWidth: 1)
                }
                .onChange(of: text) { _, _ in onEditingChanged?() }

            if let error {
                Text(error)
                    .font(.lcCaption)
                    .foregroundStyle(Color.lcCoral)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: error)
    }
}
