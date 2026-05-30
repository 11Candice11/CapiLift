//
//  NotificationsView.swift
//  CapiLift
//

import SwiftUI

// MARK: - Models

enum NotifRole: String {
    case driver    = "As Driver"
    case passenger = "As Passenger"
    case system    = "System"
}

enum NotifKind {
    case pendingRequest(from: String, destination: String, day: String, time: String)
    case accepted(driver: String)
    case tripReminder(destination: String, minutesLeft: Int, progress: Double)
    case reviewRequest(riderName: String)
}

struct AppNotification: Identifiable {
    let id = UUID()
    let role: NotifRole
    let kind: NotifKind
    let timeAgo: String
    var isRead: Bool = false
}

// MARK: - Mock data

private let pendingNotifs: [AppNotification] = [
    AppNotification(
        role: .driver,
        kind: .pendingRequest(from: "Sarah Jenkins", destination: "Stellenbosch", day: "Monday", time: "08:30 AM"),
        timeAgo: "2m ago"
    ),
]

private let recentNotifs: [AppNotification] = [
    AppNotification(
        role: .passenger,
        kind: .accepted(driver: "Marcus Thompson"),
        timeAgo: "1h ago"
    ),
    AppNotification(
        role: .driver,
        kind: .tripReminder(destination: "Cape Town CBD", minutesLeft: 60, progress: 0.65),
        timeAgo: "Yesterday"
    ),
    AppNotification(
        role: .system,
        kind: .reviewRequest(riderName: "Emily"),
        timeAgo: "2 days ago"
    ),
]

// MARK: - View

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pending = pendingNotifs
    @State private var recent  = recentNotifs

    var body: some View {
        ZStack {
            Color(hex: "F0F2F8").ignoresSafeArea()

            VStack(spacing: 0) {
                // ── Nav bar ────────────────────────────────────────
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.lcGreen)
                    }
                    Spacer()
                    Text("Notifications")
                        .font(.lcTitle3)
                        .foregroundStyle(Color.lcText)
                    Spacer()
                    Button("Mark all as read") {
                        pending = pending.map { var n = $0; n.isRead = true; return n }
                        recent  = recent.map  { var n = $0; n.isRead = true; return n }
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.lcGreen)
                }
                .padding(.horizontal, LCSpacing.md)
                .padding(.top, LCSpacing.md)
                .padding(.bottom, LCSpacing.lg)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: LCSpacing.xl) {

                        // ── Pending Requests ───────────────────────────
                        if !pending.isEmpty {
                            SectionHeader(title: "Pending Requests", badge: pending.count)
                            VStack(spacing: LCSpacing.sm) {
                                ForEach($pending) { $notif in
                                    PendingCard(notif: $notif, onAccept: {
                                        pending.removeAll { $0.id == notif.id }
                                    }, onDecline: {
                                        pending.removeAll { $0.id == notif.id }
                                    })
                                }
                            }
                            .padding(.horizontal, LCSpacing.md)
                        }

                        // ── Recent Activity ────────────────────────────
                        SectionHeader(title: "Recent Activity", badge: nil)
                        VStack(spacing: LCSpacing.sm) {
                            ForEach(recent) { notif in
                                ActivityCard(notif: notif)
                            }
                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.xxl)
                    }
                }
            }
        }
    }
}

// MARK: - Section header

private struct SectionHeader: View {
    let title: String
    let badge: Int?

    var body: some View {
        HStack(spacing: LCSpacing.xs) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.lcText)
            if let badge {
                Text("\(badge)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(Color.lcAccent)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, LCSpacing.md)
    }
}

// MARK: - Pending request card

private struct PendingCard: View {
    @Binding var notif: AppNotification
    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.md) {
            HStack(alignment: .top, spacing: LCSpacing.sm) {
                // Avatar
                Circle()
                    .fill(Color(hex: "C9A882"))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(.white)
                    }

                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    HStack {
                        RolePill(role: notif.role)
                        Spacer()
                        Text(notif.timeAgo)
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }

                    if case let .pendingRequest(from, destination, day, time) = notif.kind {
                        Group {
                            Text("\(from) ").font(.lcBodyBold).foregroundStyle(Color.lcText)
                            + Text("wants to join your ride to ").font(.lcBody).foregroundStyle(Color.lcText)
                            + Text(destination).font(.lcBodyBold).foregroundStyle(Color.lcGreen)
                            + Text(" on \(day) at \(time).").font(.lcBody).foregroundStyle(Color.lcText)
                        }
                        .lineSpacing(2)
                    }
                }
            }

            HStack(spacing: LCSpacing.sm) {
                // Car icon badge
                ZStack {
                    Circle()
                        .fill(Color.lcGreen)
                        .frame(width: 36, height: 36)
                    Image(systemName: "car.2.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(.white)
                }

                Button(action: onAccept) {
                    Text("Accept")
                        .font(.lcBodyBold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.sm)
                        .background(Color.lcGreen)
                        .clipShape(Capsule())
                }

                Button(action: onDecline) {
                    Text("Decline")
                        .font(.lcBodyBold)
                        .foregroundStyle(Color.lcText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.sm)
                        .background(Color.lcCard)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule().stroke(Color.lcBorder, lineWidth: 1.5)
                        }
                }
            }
        }
        .padding(LCSpacing.md)
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Recent activity card

private struct ActivityCard: View {
    let notif: AppNotification

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: LCSpacing.sm) {
                activityIcon
                    .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    HStack {
                        RolePill(role: notif.role)
                        Spacer()
                        Text(notif.timeAgo)
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }
                    bodyText
                }
            }
            .padding(LCSpacing.md)

            if case let .tripReminder(_, _, progress) = notif.kind {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: LCRadius.pill)
                            .fill(Color.lcBorder)
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: LCRadius.pill)
                            .fill(Color.lcGreen)
                            .frame(width: geo.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, LCSpacing.md)
                .padding(.bottom, LCSpacing.md)
            }
        }
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    @ViewBuilder
    private var activityIcon: some View {
        switch notif.kind {
        case .accepted:
            Circle()
                .fill(Color(hex: "3A3A4A"))
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
        case .tripReminder:
            Circle()
                .fill(Color.lcGreen.opacity(0.15))
                .overlay {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.lcGreen)
                }
        case .reviewRequest:
            Circle()
                .fill(Color.lcAccent.opacity(0.15))
                .overlay {
                    Image(systemName: "star")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.lcAccent)
                }
        case .pendingRequest:
            Circle()
                .fill(Color(hex: "C9A882"))
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
        }
    }

    @ViewBuilder
    private var bodyText: some View {
        switch notif.kind {
        case let .accepted(driver):
            Group {
                Text("Your request to ride with ")
                    .font(.lcBody).foregroundStyle(Color.lcText)
                + Text("\(driver) ").font(.lcBodyBold).foregroundStyle(Color.lcText)
                + Text("has been ").font(.lcBody).foregroundStyle(Color.lcText)
                + Text("accepted.").font(.lcBodyBold).foregroundStyle(Color.lcAccent)
            }
            .lineSpacing(2)

        case let .tripReminder(destination, _, _):
            Group {
                Text("Don't forget! Your trip to ")
                    .font(.lcBody).foregroundStyle(Color.lcText)
                + Text("\(destination) ").font(.lcBodyBold).foregroundStyle(Color.lcText)
                + Text("starts in 1 hour.").font(.lcBody).foregroundStyle(Color.lcText)
            }
            .lineSpacing(2)

        case let .reviewRequest(riderName):
            Group {
                Text("How was your ride with ")
                    .font(.lcBody).foregroundStyle(Color.lcText)
                + Text("\(riderName)").font(.lcBodyBold).foregroundStyle(Color.lcText)
                + Text("? Leave a review to help the LiftClub community.")
                    .font(.lcBody).foregroundStyle(Color.lcText)
            }
            .lineSpacing(2)

        case let .pendingRequest(from, destination, day, time):
            Group {
                Text("\(from) ").font(.lcBodyBold).foregroundStyle(Color.lcText)
                + Text("wants to join your ride to ").font(.lcBody).foregroundStyle(Color.lcText)
                + Text(destination).font(.lcBodyBold).foregroundStyle(Color.lcGreen)
                + Text(" on \(day) at \(time).").font(.lcBody).foregroundStyle(Color.lcText)
            }
            .lineSpacing(2)
        }
    }
}

// MARK: - Role pill

private struct RolePill: View {
    let role: NotifRole

    var body: some View {
        Text(role.rawValue)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color.lcMuted)
            .padding(.horizontal, LCSpacing.xs)
            .padding(.vertical, 4)
            .background(Color.lcBorder.opacity(0.6))
            .clipShape(Capsule())
    }
}
