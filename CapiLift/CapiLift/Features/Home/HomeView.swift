import SwiftUI

struct HomeView: View {
    @Environment(AuthState.self) private var authState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: LCSpacing.lg) {
                    HomeHeaderView()
                    HomeGreetingView()
                    HomeWeekStripView()
                    HomeSustainabilityCard()
                    HomeMatchesSection()
                }
                .padding(.bottom, LCSpacing.xl)
            }
            .background(Color.lcBackground)
            .scrollIndicators(.hidden)
        }
    }
}
