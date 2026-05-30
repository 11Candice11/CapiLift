//
//  MatchListView.swift
//  CapiLift
//

import SwiftUI

struct MatchListView: View {
    @Environment(AuthState.self) private var authState
    var embeddedInStack: Bool = false

    @State private var roleFilter: RoleFilter = .drivers
    @State private var selectedMatch: MockMatch? = nil
    @State private var showNotifications = false
    @Environment(\.dismiss) private var dismiss

    enum RoleFilter: String, CaseIterable {
        case drivers    = "Drivers"
        case passengers = "Passengers"
    }

    private var allDayLabels: [String] {
        var seen: [String] = []
        for match in MockMatch.all {
            if !seen.contains(match.dayLabel) { seen.append(match.dayLabel) }
        }
        return seen
    }

    private var filtered: [MockMatch] {
        MockMatch.all.filter { match in
            switch roleFilter {
            case .drivers:    return match.role == .driver
            case .passengers: return match.role == .passenger
            }
        }
    }

    private var grouped: [(label: String, matches: [MockMatch])] {
        allDayLabels.map { label in
            (label: label, matches: filtered.filter { $0.dayLabel == label })
        }
    }

    var body: some View {
        let content = ZStack {
            Color.lcBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // ── Header ──────────────────────────────────────────────
                HStack {
                    if embeddedInStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.lcText)
                        }
                    }

                    HStack(spacing: LCSpacing.sm) {
                        Circle()
                            .fill(Color.lcGreen.opacity(0.15))
                            .frame(width: 36, height: 36)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(Color.lcGreen)
                                    .font(.system(size: 16))
                            }
                        Text("LiftClub")
                            .font(.lcTitle2)
                            .foregroundStyle(Color.lcText)
                    }

                    Spacer()

                    Button { showNotifications = true } label: {
                        Image(systemName: "bell")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(Color.lcText)
                    }
                    .sheet(isPresented: $showNotifications) {
                        NotificationsView()
                    }
                }
                .padding(.horizontal, LCSpacing.md)
                .padding(.top, LCSpacing.md)
                .padding(.bottom, LCSpacing.sm)

                // ── Section title ────────────────────────────────────────
                VStack(alignment: .leading, spacing: 2) {
                    Text("YOUR NETWORK")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.lcGreen)
                        .tracking(1.2)
                    Text("Daily Matches")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, LCSpacing.md)
                .padding(.bottom, LCSpacing.md)

                // ── Pill toggle ──────────────────────────────────────────
                HStack(spacing: 0) {
                    ForEach(RoleFilter.allCases, id: \.self) { filter in
                        Button {
                            roleFilter = filter
                        } label: {
                            Text(filter.rawValue)
                                .font(.lcBodyBold)
                                .foregroundStyle(roleFilter == filter ? .white : Color.lcText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, LCSpacing.xs)
                                .background(roleFilter == filter ? Color.lcCoral : Color.clear)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(4)
                .background(Color.lcBorder.opacity(0.5))
                .clipShape(Capsule())
                .padding(.horizontal, LCSpacing.md)
                .padding(.bottom, LCSpacing.md)

                // ── Grouped list ─────────────────────────────────────────
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(grouped, id: \.label) { group in
                            DaySectionHeader(label: group.label)

                            if group.matches.isEmpty {
                                EmptyDayCard(dayLabel: group.label)
                                    .padding(.horizontal, LCSpacing.md)
                                    .padding(.bottom, LCSpacing.md)
                            } else {
                                ForEach(group.matches) { match in
                                    Button {
                                        selectedMatch = match
                                    } label: {
                                        MatchRowCard(match: match)
                                            .padding(.horizontal, LCSpacing.md)
                                            .padding(.bottom, LCSpacing.sm)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.bottom, LCSpacing.xl)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $selectedMatch) { match in
            RouteDetailView(match: match)
        }

        if embeddedInStack {
            content
        } else {
            NavigationStack { content }
        }
    }
}

// MARK: - Day Section Header

private struct DaySectionHeader: View {
    let label: String

    var body: some View {
        HStack(spacing: LCSpacing.sm) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.lcMuted)
                .tracking(0.8)
                .fixedSize()

            Rectangle()
                .fill(Color.lcBorder)
                .frame(height: 1)
        }
        .padding(.horizontal, LCSpacing.md)
        .padding(.top, LCSpacing.md)
        .padding(.bottom, LCSpacing.sm)
    }
}

// MARK: - Empty Day Card

private struct EmptyDayCard: View {
    let dayLabel: String

    var body: some View {
        VStack(spacing: LCSpacing.sm) {
            Image(systemName: "calendar.badge.minus")
                .font(.system(size: 28))
                .foregroundStyle(Color.lcMuted.opacity(0.5))
            Text("No matches scheduled for")
                .font(.lcCaption)
                .foregroundStyle(Color.lcMuted)
            Text("\(dayLabel.capitalized) yet.")
                .font(.lcCaption)
                .foregroundStyle(Color.lcMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, LCSpacing.lg)
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
        .overlay {
            RoundedRectangle(cornerRadius: LCRadius.lg)
                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundStyle(Color.lcBorder)
        }
    }
}

// MARK: - Match Row Card

private struct MatchRowCard: View {
    let match: MockMatch

    private var badgeColor: Color {
        switch match.matchBadge {
        case .verified: return Color.lcCoral
        case .regular:  return Color.lcMuted
        case .newMatch: return Color.lcCoral
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: LCSpacing.sm) {
                // Left accent bar
                RoundedRectangle(cornerRadius: LCRadius.pill)
                    .fill(Color.lcGreen)
                    .frame(width: 4)
                    .padding(.vertical, LCSpacing.xs)

                // Avatar
                Circle()
                    .fill(Color.lcGreen.opacity(0.12))
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Color.lcGreen.opacity(0.5))
                    }

                // Name + location
                VStack(alignment: .leading, spacing: 3) {
                    Text(match.driverName)
                        .font(.lcBodyBold)
                        .foregroundStyle(Color.lcText)
                    HStack(spacing: 3) {
                        Image(systemName: "mappin")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.lcMuted)
                        Text(match.locationLabel)
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }
                }

                Spacer()

                // Badge
                Text(match.matchBadge.rawValue)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(badgeColor)
                    .padding(.horizontal, LCSpacing.xs)
                    .padding(.vertical, 4)
                    .background(badgeColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.sm))
            }
            .padding(.horizontal, LCSpacing.sm)
            .padding(.top, LCSpacing.sm)

            Divider()
                .padding(.horizontal, LCSpacing.sm)
                .padding(.top, LCSpacing.xs)

            // Bottom row: time + view route
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.lcGreen)
                    Text(match.pickupTime)
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcText)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text("View Route")
                        .font(.lcBodyBold)
                        .foregroundStyle(Color.lcGreen)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.lcGreen)
                }
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.vertical, LCSpacing.sm)
        }
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

// Keep MatchListCard for HomeMatchesSection compatibility
struct MatchListCard: View {
    let match: MockMatch
    var body: some View {
        MatchRowCard(match: match)
    }
}
