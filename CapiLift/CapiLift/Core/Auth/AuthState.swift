import SwiftUI

@Observable
final class AuthState {
    var currentUser: User? = nil          // nil = not logged in → shows onboarding
    var hasCompletedSSO: Bool = false     // false = shows sign-in first
    var isAuthenticated: Bool { currentUser != nil }

    /// Set to a driver's first name to trigger the post-ride review sheet
    var pendingReviewDriver: String? = nil

    func signOut() {
        KeychainService.shared.deleteToken()
        currentUser = nil
        hasCompletedSSO = false
    }
}
