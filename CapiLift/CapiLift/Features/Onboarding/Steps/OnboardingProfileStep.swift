//
//  OnboardingProfileStep.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct OnboardingProfileStep: View {
    @Binding var profile: OnboardingProfile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {
                // Title
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Create Profile")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                    Text("Tell us a bit about yourself so colleagues can recognise you.")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(4)
                }

                // Profile photo
                HStack {
                    Spacer()
                    VStack(spacing: LCSpacing.xs) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color.lcGreen.opacity(0.12))
                                .frame(width: 100, height: 100)
                            Image(systemName: "person.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(Color.lcGreen.opacity(0.4))
                                .frame(width: 100, height: 100)
                            Circle()
                                .fill(Color.lcGreen)
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.white)
                                }
                                .offset(x: 4, y: 4)
                        }
                        Text("Add Profile Photo")
                            .font(.lcCaptionBold)
                            .foregroundStyle(Color.lcGreen)
                    }
                    Spacer()
                }

                // Fields
                VStack(spacing: LCSpacing.md) {
                    LCTextField(
                        label: "Full Name",
                        placeholder: "John Doe",
                        text: $profile.fullName
                    )

                    LCTextField(
                        label: "Work Email",
                        placeholder: "yourname@company.com",
                        text: $profile.email,
                        keyboardType: .emailAddress
                    )
                }
            }
            .padding(.horizontal, LCSpacing.md)
        }
    }
}