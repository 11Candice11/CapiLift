import SwiftUI
import MapKit

struct ChatView: View {
    let match: MockMatch
    @Environment(AuthState.self) private var authState
    @State private var viewModel: ChatViewModel?

    var body: some View {
        ZStack {
            Color.lcCard.ignoresSafeArea()
            if let vm = viewModel {
                VStack(spacing: 0) {
                    ChatHeaderView(
                        title: vm.matchTitle,
                        subtitle: vm.matchSubtitle
                    )

                    ChatMessagesView(vm: vm, currentUserId: authState.currentUser?.id ?? UUID())

                    ChatInputBarWrapper(vm: vm)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if viewModel == nil {
                viewModel = ChatViewModel(
                    currentUserId: authState.currentUser?.id ?? UUID(),
                    match: match
                )
            }
        }
    }
}

// MARK: - Messages list

private struct ChatMessagesView: View {
    let vm: ChatViewModel
    let currentUserId: UUID

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {

                    // CO2 banner at top
                    CO2Banner(co2Saved: vm.co2Saved)
                        .padding(.top, LCSpacing.lg)
                        .padding(.bottom, LCSpacing.sm)

                    // Match timestamp separator
                    Text("MATCHED TODAY • \(matchedTimeString)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.lcMuted)
                        .tracking(0.8)
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.vertical, LCSpacing.xxs + 2)
                        .background(Color.lcBorder.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                        .padding(.bottom, LCSpacing.lg)

                    ForEach(vm.groupedMessages()) { group in
                        ForEach(group.messages) { message in
                            MessageBubble(
                                message: message,
                                currentUserId: currentUserId,
                                showSenderName: vm.isGroupChat && message.sender.id != currentUserId
                            )
                            .id(message.id)
                        }
                    }

                    // Map snippet at bottom
                    MapSnippet(coordinate: CLLocationCoordinate2D(
                        latitude: vm.driverLat,
                        longitude: vm.driverLng
                    ))
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.top, LCSpacing.sm)

                    Color.clear.frame(height: 1).id("bottom")
                }
                .padding(.bottom, LCSpacing.md)
            }
            .background(Color.lcBackground)
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
            .onChange(of: vm.messages.count) { _, _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
        }
    }

    private var matchedTimeString: String {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        return f.string(from: Date())
    }
}

// MARK: - Map snippet

private struct MapSnippet: View {
    let coordinate: CLLocationCoordinate2D

    var body: some View {
        Map(position: .constant(.region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))) {
            Marker("", coordinate: coordinate).tint(Color.lcGreen)
        }
        .frame(height: 130)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
        .allowsHitTesting(false)
    }
}

// MARK: - Input wrapper

private struct ChatInputBarWrapper: View {
    @Bindable var vm: ChatViewModel

    var body: some View {
        ChatInputBar(
            text: $vm.newMessage,
            onSend: { vm.sendMessage() }
        )
    }
}
