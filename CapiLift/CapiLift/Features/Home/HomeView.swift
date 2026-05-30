import SwiftUI

struct HomeView: View {
    @Environment(AuthState.self) private var authState
    @State private var showReview = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: LCSpacing.lg) {
                    HomeHeaderView()
                    HomeSustainabilityCard()
                    HomeWeekStripView()
                    HomeMatchesSection()
                }
                .padding(.bottom, LCSpacing.xxl)
            }
            .background(Color.lcBackground.ignoresSafeArea())
        }
        .sheet(isPresented: $showReview) {
            if let driver = authState.pendingReviewDriver {
                DriveReviewSheet(
                    driverFirstName: driver,
                    onSubmit: { _, _ in authState.pendingReviewDriver = nil },
                    onReport:  { authState.pendingReviewDriver = nil },
                    onDismiss: { authState.pendingReviewDriver = nil }
                )
            }
        }
        .onAppear {
            if authState.pendingReviewDriver != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showReview = true
                }
            }
        }
        .onChange(of: authState.pendingReviewDriver) { _, newVal in
            if newVal != nil { showReview = true }
        }
    }
}
