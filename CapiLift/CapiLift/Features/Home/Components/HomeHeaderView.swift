import SwiftUI

struct HomeHeaderView: View {
    @Environment(AuthState.self) private var authState
    @State private var showNotifications = false

    private var firstName: String {
        authState.currentUser?.fullName.components(separatedBy: " ").first ?? "there"
    }

    private var totalPoints: Int {
        authState.currentUser?.totalPoints ?? 1250
    }

    var body: some View {
        HStack(alignment: .center) {
            // App name
            Text("LiftClub")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.lcGreen)

            Spacer()

            // Points pill
            HStack(spacing: LCSpacing.xs) {
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcGreen)
                Text("\(totalPoints) pts")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.lcText)
            }
            .padding(.horizontal, LCSpacing.sm)
            .padding(.vertical, LCSpacing.xxs + 2)
            .background(Color.lcCard)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.lcBorder, lineWidth: 1))
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            // Avatar
            Button { showNotifications = true } label: {
                Circle()
                    .fill(Color.lcGreen.opacity(0.15))
                    .frame(width: 38, height: 38)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.lcGreen)
                    }
            }
            .padding(.leading, LCSpacing.xs)
        }
        .padding(.horizontal, LCSpacing.md)
        .padding(.top, LCSpacing.md)
        .padding(.bottom, LCSpacing.xs)
        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }
    }
}
