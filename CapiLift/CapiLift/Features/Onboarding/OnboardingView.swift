import SwiftUI

struct OnboardingView: View {
    @Environment(AuthState.self) private var authState
    @State private var step = 1
    @State private var profile = OnboardingProfile()

    private var isDriver: Bool {
        profile.role == .driver || profile.role == .both
    }

    private var totalSteps: Int { isDriver ? 5 : 4 }

    private var ctaTitle: String {
        step == totalSteps ? "Let's find your matches →" : "Continue"
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.lcBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                LCOnboardingHeader(step: step, totalSteps: totalSteps, onBack: step > 1 ? {
                    withAnimation(.spring(response: 0.3)) { step -= 1 }
                } : nil)

                Group {
                    switch step {
                    case 1:
                        OnboardingProfileStep(profile: $profile)
                    case 2:
                        OnboardingLocationStep(profile: $profile)
                    case 3:
                        OnboardingCampusStep(profile: $profile)
                    case 4:
                        if isDriver {
                            OnboardingCarStep(profile: $profile)
                        } else {
                            OnboardingScheduleStep(profile: $profile)
                        }
                    case 5:
                        OnboardingScheduleStep(profile: $profile)
                    default:
                        EmptyView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                .id(step)

                Spacer()

                LCPrimaryButton(title: ctaTitle) {
                    withAnimation(.spring(response: 0.3)) {
                        if step < totalSteps {
                            step += 1
                        } else {
                            completeOnboarding()
                        }
                    }
                }
                .padding(.horizontal, LCSpacing.md)
                .padding(.bottom, LCSpacing.xl)
            }
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
