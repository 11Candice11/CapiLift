import SwiftUI

@Observable
final class AuthState {
    var currentUser: User? = nil
    var hasCompletedSSO: Bool = false
    var isAuthenticated: Bool { currentUser != nil }

    func signOut() {
        KeychainService.shared.deleteToken()
        currentUser = nil
        hasCompletedSSO = false
    }
}
