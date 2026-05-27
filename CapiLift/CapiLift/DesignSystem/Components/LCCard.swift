import SwiftUI

struct LCCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
