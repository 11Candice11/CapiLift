import SwiftUI

@main
struct CapiLiftApp: App {
    @State private var authState    = AuthState()
    @State private var router       = AppRouter()
    @State private var tabSelection = TabSelection()

    var body: some Scene {
        WindowGroup {
            Group {
                if authState.isAuthenticated {
                    MainTabView()
                } else if authState.hasCompletedSSO {
                    OnboardingView()
                } else {
                    SignInView()
                }
            }
            .environment(authState)
            .environment(router)
            .environment(tabSelection)
        }
    }
}
