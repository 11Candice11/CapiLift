import SwiftUI

struct ChatListView: View {
    @Environment(AuthState.self) private var authState
    @State private var searchText = ""
    @State private var selectedMatch: MockMatch? = nil
    @State private var showNotifications = false

    private var conversations = MockConversation.mockList()

    private var filtered: [MockConversation] {
        guard !searchText.isEmpty else { return conversations }
        return conversations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.lastMessage.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lcBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // ── Header ───────────────────────────────────────
                    HStack {
                        HStack(spacing: LCSpacing.xs) {
                            Image(systemName: "car.2.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.lcGreen)
                            Text("CapiLift")
                                .font(.lcBodyBold)
                                .foregroundStyle(Color.lcText)
                        }
                        Spacer()
                        Button { showNotifications = true } label: {
                            Image(systemName: "bell")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.lcText)
                        }
                        .sheet(isPresented: $showNotifications) {
                            NotificationsView()
                        }
                    }
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.top, LCSpacing.md)
                    .padding(.bottom, LCSpacing.sm)

                    // ── Title ────────────────────────────────────────
                    Text("Messages")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.md)

                    // ── Search ───────────────────────────────────────
                    HStack(spacing: LCSpacing.sm) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.lcMuted)
                            .font(.system(size: 15))
                        TextField("Search conversations...", text: $searchText)
                            .font(.lcBody)
                    }
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.vertical, LCSpacing.sm)
                    .background(Color.lcCard)
                    .overlay(alignment: .bottom) { Divider() }
                    .padding(.bottom, LCSpacing.xs)

                    // ── List ─────────────────────────────────────────
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(filtered) { convo in
                                NavigationLink {
                                    ChatView(match: MockMatch.david)
                                } label: {
                                    ConversationRow(convo: convo)
                                }
                                .buttonStyle(.plain)

                                Divider()
                                    .padding(.leading, 80)
                            }

                            // ── Find a ride CTA ───────────────────────
                            FindRideBanner()
                                .padding(.horizontal, LCSpacing.md)
                                .padding(.top, LCSpacing.lg)
                                .padding(.bottom, LCSpacing.xl)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Conversation Row

private struct ConversationRow: View {
    let convo: MockConversation

    var body: some View {
        HStack(spacing: LCSpacing.md) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.lcGreen.opacity(0.12))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(Color.lcGreen.opacity(0.45))
                    }

                if convo.isOnline {
                    Circle()
                        .fill(Color.lcGreen)
                        .frame(width: 13, height: 13)
                        .overlay { Circle().stroke(Color.lcBackground, lineWidth: 2) }
                }
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                // Name row
                HStack(alignment: .firstTextBaseline, spacing: LCSpacing.xs) {
                    Text(convo.name)
                        .font(.lcBodyBold)
                        .foregroundStyle(Color.lcText)

                    if convo.hasVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.lcGreen)
                    }

                    Spacer()

                    Text(convo.timeString)
                        .font(.lcCaption)
                        .foregroundStyle(convo.unreadCount > 0 ? Color.lcGreen : Color.lcMuted)
                        .fontWeight(convo.unreadCount > 0 ? .semibold : .regular)
                }

                // Message + tag row
                HStack(alignment: .center, spacing: LCSpacing.xs) {
                    Text(convo.lastMessage)
                        .font(convo.unreadCount > 0 ? .lcBodyBold : .lcBody)
                        .foregroundStyle(convo.unreadCount > 0 ? Color.lcText : Color.lcMuted)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Tag pill
                    if let tag = convo.tag {
                        switch tag {
                        case .points(let n):
                            HStack(spacing: 3) {
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color.lcSecondary)
                                Text("+\(n)")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(Color.lcText)
                            }
                            .padding(.horizontal, LCSpacing.xs)
                            .padding(.vertical, 3)
                            .background(Color.lcSecondary.opacity(0.18))
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))

                        case .matches:
                            HStack(spacing: 3) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color.lcMuted)
                                Text("Matches")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(Color.lcMuted)
                            }
                            .padding(.horizontal, LCSpacing.xs)
                            .padding(.vertical, 3)
                            .background(Color.lcBorder)
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                        }
                    }

                    // Unread dot
                    if convo.unreadCount > 0 && convo.tag == nil {
                        Circle()
                            .fill(Color.lcGreen)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .padding(.horizontal, LCSpacing.md)
        .padding(.vertical, LCSpacing.md)
        .background(Color.lcCard)
    }
}

// MARK: - Find Ride Banner

private struct FindRideBanner: View {
    var body: some View {
        VStack(spacing: LCSpacing.sm) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(Color.lcMuted.opacity(0.5))

            Text("Looking for more matches?")
                .font(.lcBody)
                .foregroundStyle(Color.lcMuted)

            Button {
                // navigate to matches
            } label: {
                Text("Find a Ride →")
                    .font(.lcBodyBold)
                    .foregroundStyle(Color.lcGreen)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, LCSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: LCRadius.lg)
                .stroke(Color.lcBorder, style: StrokeStyle(lineWidth: 1, dash: [6]))
        )
    }
}
