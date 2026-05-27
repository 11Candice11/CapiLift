import SwiftUI

struct SignInView: View {
    @Environment(AuthState.self) private var authState
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // Background
            Color.lcBackground
                .ignoresSafeArea()
            
            // Soft abstract circles for visual warmth
            GeometryReader { geo in
                Circle()
                    .fill(Color.lcGreen.opacity(0.08))
                    .frame(width: geo.size.width * 1.2)
                    .offset(x: -geo.size.width * 0.2, y: -geo.size.height * 0.1)
                
                Circle()
                    .fill(Color.lcCoral.opacity(0.07))
                    .frame(width: geo.size.width * 0.8)
                    .offset(x: geo.size.width * 0.4, y: geo.size.height * 0.55)
            }
            .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                Spacer()
                
                // Logo area
                VStack(spacing: LCSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(Color.lcGreen)
                            .frame(width: 80, height: 80)
                        Image(systemName: "car.2.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    
                    VStack(spacing: LCSpacing.xs) {
                        Text("CapiLift")
                            .font(.lcLargeTitle)
                            .foregroundStyle(Color.lcText)
                        
                        Text("Ride together. Go further.")
                            .font(.lcCallout)
                            .foregroundStyle(Color.lcMuted)
                    }
                }
                
                Spacer()
                
                // Sign in card
                VStack(spacing: LCSpacing.lg) {
                    VStack(spacing: LCSpacing.xs) {
                        Text("Welcome")
                            .font(.lcTitle2)
                            .foregroundStyle(Color.lcText)
                        
                        Text("Sign in with your company account\nto connect with colleagues.")
                            .font(.lcCallout)
                            .foregroundStyle(Color.lcMuted)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    
                    // Microsoft SSO button
                    Button {
                        handleSignIn()
                    } label: {
                        HStack(spacing: LCSpacing.sm) {
                            Image(systemName: "person.badge.key.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Sign in with Microsoft")
                                .font(.lcBodyBold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.md)
                        .background(Color.lcGreen)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                    }
                    
                    Text("Only employees can join CapiLift.")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)
                }
                .padding(LCSpacing.lg)
                .background(Color.lcCard)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
                .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 4)
                .padding(.horizontal, LCSpacing.md)
                
                Spacer()
                    .frame(height: LCSpacing.xl)
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
