import SwiftUI

struct OnboardingView: View {
    @Environment(AuthState.self) private var authState
    @State private var step = 1
    @State private var profile = OnboardingProfile()
    @State private var showValidationError = false

    private let totalSteps = 6

    private var stepLabel: String {
        switch step {
        case 1: return "Identity"
        case 2: return "Location"
        case 3: return "Campus"
        case 4: return "Role"
        case 5: return "Vehicle"
        case 6: return "Schedule"
        default: return ""
        }
    }

    private var canAdvance: Bool {
        switch step {
        case 1: return step1Valid
        case 2: return step2Valid
        case 3: return true
        case 4: return profile.role != nil
        case 5: return step5Valid
        case 6: return true
        default: return true
        }
    }

    private var step1Valid: Bool {
        let parts = profile.fullName.trimmingCharacters(in: .whitespaces).split(separator: " ")
        return parts.count >= 2
    }

    private var step2Valid: Bool { !profile.homeAddress.isEmpty }

    private var step5Valid: Bool {
        guard let role = profile.role else { return true }
        if role == .driver || role == .both {
            return !profile.carMake.isEmpty && !profile.carModel.isEmpty &&
                   !profile.carColour.isEmpty && !profile.licensePlate.isEmpty
        }
        return true
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ──────────────────────────────────────────────
            HStack {
                Spacer()
                HStack(spacing: LCSpacing.xs) {
                    ZStack {
                        Circle()
                            .fill(Color.lcGreen)
                            .frame(width: 40, height: 40)
                        Image(systemName: "car.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    Text("CapiLift")
                        .font(.lcTitle2)
                        .foregroundStyle(Color.lcGreen)
                }
                Spacer()
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.top, LCSpacing.md)
            .padding(.bottom, LCSpacing.md)

            // ── Progress bar + step label ─────────────────────────────
            VStack(alignment: .leading, spacing: LCSpacing.xs) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.lcBorder)
                            .frame(height: 3)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.lcGreen)
                            .frame(width: geo.size.width * (Double(step) / Double(totalSteps)), height: 3)
                            .animation(.spring(response: 0.4), value: step)
                    }
                }
                .frame(height: 3)

                HStack {
                    Text("STEP \(step) OF \(totalSteps)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.lcGreen)
                        .tracking(0.8)
                    Spacer()
                    Text(stepLabel)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.lcMuted)
                        .tracking(0.4)
                }
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.bottom, LCSpacing.md)

            // ── Step content ─────────────────────────────────────────
            Group {
                switch step {
                case 1: OnboardingProfileStep(profile: $profile)
                case 2: OnboardingLocationStep(profile: $profile)
                case 3: OnboardingCampusStep(profile: $profile)
                case 4: OnboardingRoleStep(profile: $profile)
                case 5: OnboardingVehicleStep(profile: $profile)
                case 6: OnboardingScheduleStep(profile: $profile)
                default: EmptyView()
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            ))
            .id(step)

            Spacer()

            // ── Validation hint ──────────────────────────────────────
            if showValidationError && !canAdvance {
                HStack(spacing: LCSpacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                    Text(validationHint)
                        .font(.lcCaption)
                }
                .foregroundStyle(Color.lcCoral)
                .padding(.horizontal, LCSpacing.md)
                .padding(.bottom, LCSpacing.xs)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            // ── Footer ───────────────────────────────────────────────
            VStack(spacing: LCSpacing.sm) {
                Button {
                    if canAdvance {
                        showValidationError = false
                        withAnimation(.spring(response: 0.3)) {
                            if step < totalSteps { step += 1 } else { completeOnboarding() }
                        }
                    } else {
                        withAnimation { showValidationError = true }
                    }
                } label: {
                    HStack(spacing: LCSpacing.xs) {
                        Text(step == totalSteps ? "FINISH" : step == 5 && profile.role != .passenger ? "SAVE CAR" : "CONTINUE")
                            .font(.system(size: 15, weight: .bold))
                            .tracking(1)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, LCSpacing.md)
                    .background(canAdvance ? Color.lcAccent : Color.lcAccent.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                }
                .animation(.easeInOut(duration: 0.2), value: canAdvance)

                if step == 1 {
                    HStack(spacing: 3) {
                        Text("By continuing, you agree to our")
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                        Button { } label: {
                            Text("Privacy Policy")
                                .font(.lcCaption)
                                .foregroundStyle(Color.lcGreen)
                        }
                    }
                    .padding(.top, LCSpacing.xxs)
                } else {
                    Button {
                        withAnimation(.spring(response: 0.3)) { step -= 1 }
                        showValidationError = false
                    } label: {
                        Text("Back")
                            .font(.lcBody)
                            .foregroundStyle(Color.lcMuted)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, LCSpacing.sm)
                    }
                }

                if step == 4 {
                    Text("You can change this later in settings")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)
                }
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.bottom, LCSpacing.xl)
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "C9D4F5"), Color(hex: "EDE9F8"), Color(hex: "F5EFF0")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    private var validationHint: String {
        switch step {
        case 1: return "Please enter your first and last name"
        case 2: return "Please select your home address from the suggestions"
        case 4: return "Please select how you commute"
        case 5: return "Please complete your vehicle details to continue"
        default: return ""
        }
    }

    private func completeOnboarding() {
        authState.currentUser = User(
            id: UUID(),
            fullName: profile.fullName,
            email: profile.email,
            employeeId: "EMP001",
            homeAddress: profile.homeAddress,
            homeLat: profile.homeLat,
            homeLng: profile.homeLng,
            campus: profile.campus ?? .stellenbosch,
            totalPoints: 0
        )
    }
}
