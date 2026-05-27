import SwiftUI

@Observable
final class AppRouter {
    var path = NavigationPath()

    enum Destination: Hashable {
        case matchDetail(matchId: UUID)
        case chat(matchId: UUID)
        case rewards
    }

    func push(_ destination: Destination) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
