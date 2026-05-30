import SwiftUI

struct SignInView: View {
    @Environment(AuthState.self) private var authState
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color(hex: "F0F2F8").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Logo ─────────────────────────────────────────
                    VStack(spacing: LCSpacing.sm) {
                        ZStack {
                            Circle()
                                .fill(Color.lcGreen)
                                .frame(width: 72, height: 72)
                            Image(systemName: "car.2.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(.white)
                        }

                        Text("LiftClub")
                            .font(.lcTitle)
                            .foregroundStyle(Color.lcText)

                        Text("Carpooling made simple")
                            .font(.lcCallout)
                            .foregroundStyle(Color.lcMuted)
                    }
                    .padding(.top, LCSpacing.xxl)
                    .padding(.bottom, LCSpacing.lg)

                    // ── Hero image card ───────────────────────────────
                    ZStack(alignment: .bottom) {
                        // Photo — drop signin_hero.jpg into Assets.xcassets/signin_hero.imageset/
                        if let _ = UIImage(named: "signin_hero") {
                            Image("signin_hero")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 320)
                                .clipped()
                        } else {
                            // Placeholder until image is added
                            LinearGradient(
                                colors: [Color(hex: "1A2E3B"), Color(hex: "2C4A5E"), Color(hex: "3A6E8A")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 320)
                            .overlay {
                                VStack(spacing: LCSpacing.sm) {
                                    Image(systemName: "road.lanes.curved.right")
                                        .font(.system(size: 48))
                                        .foregroundStyle(.white.opacity(0.4))
                                    Text("Add signin_hero.jpg to\nAssets.xcassets/signin_hero.imageset/")
                                        .font(.lcCaption)
                                        .foregroundStyle(.white.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }

                        // Gradient scrim at bottom for pill readability
                        LinearGradient(
                            colors: [.black.opacity(0.55), .clear],
                            startPoint: .bottom,
                            endPoint: .center
                        )
                        .frame(height: 120)

                        // Stats pills
                        HStack(spacing: 0) {
                            Label("5.2k Tons saved", systemImage: "leaf.fill")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.lcText)
                                .padding(.horizontal, LCSpacing.md)
                                .padding(.vertical, LCSpacing.xs)
                                .background(.white)
                                .clipShape(Capsule())

                            Circle()
                                .fill(Color.lcAccent)
                                .frame(width: 12, height: 12)
                                .offset(x: -6)

                            Label("Live Network", systemImage: "person.2.fill")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.lcText)
                                .padding(.horizontal, LCSpacing.md)
                                .padding(.vertical, LCSpacing.xs)
                                .background(.white)
                                .clipShape(Capsule())
                                .offset(x: -6)
                        }
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
                        .padding(.bottom, LCSpacing.md)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
                    .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 8)
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.bottom, LCSpacing.xl)

                    // ── Microsoft button ──────────────────────────────
                    Button {
                        handleSignIn()
                    } label: {
                        HStack(spacing: LCSpacing.sm) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.white)
                                .frame(width: 22, height: 22)
                                .overlay {
                                    Image(systemName: "squareshape.split.2x2")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(Color.lcGreen)
                                }
                            Text("Sign in with Microsoft")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.md)
                        .background(Color.lcGreen)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                    }
                    .padding(.horizontal, LCSpacing.md)

                    // ── Divider ───────────────────────────────────────
                    HStack(spacing: LCSpacing.sm) {
                        Rectangle()
                            .fill(Color.lcBorder)
                            .frame(height: 1)
                        Text("OR")
                            .font(.lcCaptionBold)
                            .foregroundStyle(Color.lcMuted)
                        Rectangle()
                            .fill(Color.lcBorder)
                            .frame(height: 1)
                    }
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.vertical, LCSpacing.lg)

                    // ── Corporate email button ────────────────────────
                    Button {
                        handleSignIn()
                    } label: {
                        HStack(spacing: LCSpacing.sm) {
                            Image(systemName: "envelope")
                                .font(.system(size: 16, weight: .medium))
                            Text("Continue with Corporate Email")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundStyle(Color.lcText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.md)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                        .overlay {
                            RoundedRectangle(cornerRadius: LCRadius.pill)
                                .stroke(Color.lcBorder, lineWidth: 1.5)
                        }
                    }
                    .padding(.horizontal, LCSpacing.md)

                    // ── Legal ─────────────────────────────────────────
                    Group {
                        Text("By signing in, you agree to our ")
                            .foregroundStyle(Color.lcMuted)
                        + Text("Terms of Service")
                            .foregroundStyle(Color.lcGreen)
                        + Text(" and\n")
                            .foregroundStyle(Color.lcMuted)
                        + Text("Privacy Policy")
                            .foregroundStyle(Color.lcGreen)
                        + Text(".")
                            .foregroundStyle(Color.lcMuted)
                    }
                    .font(.lcCaption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, LCSpacing.lg)
                    .padding(.top, LCSpacing.lg)
                    .padding(.bottom, LCSpacing.xxl)
                }
            }
        }
    }

    private func handleSignIn() {
        isLoading = true
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            authState.hasCompletedSSO = true
            isLoading = false
        }
    }
}

#Preview {
    SignInView()
        .environment(AuthState())
}
