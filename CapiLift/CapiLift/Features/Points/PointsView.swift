//
//  PointsView.swift
//  CapiLift
//

import SwiftUI

// MARK: - Mock activity data

private struct ActivityEntry: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let points: Int
    let icon: String
    let iconBg: Color
}

private let mockActivity: [ActivityEntry] = [
    ActivityEntry(title: "Shared commute with Sarah",  subtitle: "Today · 08:45 AM",       points: 12, icon: "person.fill",  iconBg: Color(hex: "C9A882")),
    ActivityEntry(title: "Carbon Hero Milestone",      subtitle: "Yesterday · 06:12 PM",    points: 25, icon: "person.fill",  iconBg: Color(hex: "7A8B99")),
    ActivityEntry(title: "First EV Ride Bonus",        subtitle: "2 days ago",               points: 60, icon: "car.fill",     iconBg: Color(hex: "0052CC")),
]

private let chartValues: [CGFloat] = [0.22, 0.42, 0.58, 0.92, 0.36, 0.18, 0.12]
private let chartDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
private let chartHighlight = 3  // Thu

// MARK: - View

struct PointsView: View {
    @Environment(AuthState.self) private var authState

    @State private var showNotifications = false

    var totalPoints: Int { authState.currentUser?.totalPoints ?? 148 }
    var co2Saved: Int    { max(1, Int(Double(totalPoints) / 3.5)) }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lcBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        // ── Header ─────────────────────────────────────
                        HStack {
                            HStack(spacing: LCSpacing.xs) {
                                Image(systemName: "car.2.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color.lcGreen)
                                Text("LiftClub")
                                    .font(.lcTitle3)
                                    .foregroundStyle(Color.lcText)
                            }
                            Spacer()
                            Button { showNotifications = true } label: {
                                ZStack(alignment: .topTrailing) {
                                    Circle()
                                        .fill(Color.lcBorder)
                                        .frame(width: 40, height: 40)
                                        .overlay {
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 18))
                                                .foregroundStyle(Color.lcMuted)
                                        }
                                    Circle()
                                        .fill(Color.lcAccent)
                                        .frame(width: 14, height: 14)
                                        .overlay {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 7, weight: .bold))
                                                .foregroundStyle(.white)
                                        }
                                        .offset(x: 2, y: -2)
                                }
                            }
                            .buttonStyle(.plain)
                            .sheet(isPresented: $showNotifications) {
                                NotificationsView()
                            }
                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.top, LCSpacing.md)
                        .padding(.bottom, LCSpacing.lg)

                        // ── Points hero ────────────────────────────────
                        HStack(alignment: .center, spacing: LCSpacing.sm) {
                            Text("Top 5%")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, LCSpacing.sm)
                                .padding(.vertical, 6)
                                .background(Color.lcAccent)
                                .clipShape(Capsule())

                            Text("\(totalPoints) pts")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundStyle(Color.lcGreen)
                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.xs)

                        // CO2 line
                        Group {
                            Text("You've saved ")
                            + Text("\(co2Saved)kg of CO")
                            + Text("2").font(.system(size: 11)).baselineOffset(-3)
                            + Text(" this month.")
                        }
                        .font(.lcBody)
                        .foregroundStyle(Color.lcText)
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.xl)

                        // ── Impact Trajectory card ──────────────────────
                        VStack(alignment: .leading, spacing: LCSpacing.sm) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Impact Trajectory")
                                        .font(.lcTitle3)
                                        .foregroundStyle(Color.lcText)
                                    Text("Points earned over last 7 days")
                                        .font(.lcCaption)
                                        .foregroundStyle(Color.lcMuted)
                                }
                                Spacer()
                                Text("+18% vs LW")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color.lcGreen)
                                    .padding(.horizontal, LCSpacing.xs)
                                    .padding(.vertical, 5)
                                    .background(Color.lcGreen.opacity(0.12))
                                    .clipShape(Capsule())
                            }

                            // Bar chart
                            GeometryReader { geo in
                                HStack(alignment: .bottom, spacing: 6) {
                                    ForEach(chartValues.indices, id: \.self) { i in
                                        VStack(spacing: 6) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(i == chartHighlight ? Color.lcGreen : Color.lcBorder)
                                                .frame(
                                                    width: (geo.size.width - CGFloat(chartValues.count - 1) * 6) / CGFloat(chartValues.count),
                                                    height: max(8, geo.size.height * 0.82 * chartValues[i])
                                                )
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            }
                            .frame(height: 90)
                            .padding(.top, LCSpacing.xs)

                            // Day labels
                            HStack(spacing: 0) {
                                ForEach(chartDays.indices, id: \.self) { i in
                                    Text(chartDays[i])
                                        .font(.system(size: 11, weight: i == chartHighlight ? .semibold : .regular))
                                        .foregroundStyle(i == chartHighlight ? Color.lcText : Color.lcMuted)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(LCSpacing.md)
                        .background(Color.lcCard)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 3)
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.md)

                        // ── Action buttons ──────────────────────────────
                        HStack(spacing: LCSpacing.sm) {
                            NavigationLink {
                                RewardsView()
                            } label: {
                                Label("Redeem\nRewards", systemImage: "tag.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, LCSpacing.md)
                                    .background(Color.lcGreen)
                                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
                            }

                            Button { } label: {
                                Label("Leaderboard", systemImage: "chart.bar.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color.lcText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, LCSpacing.md)
                                    .background(Color.lcCard)
                                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: LCRadius.xl)
                                            .stroke(Color.lcBorder, lineWidth: 1.5)
                                    }
                            }
                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.xl)

                        // ── Recent Activity ─────────────────────────────
                        HStack {
                            Text("Recent Activity")
                                .font(.lcTitle3)
                                .foregroundStyle(Color.lcText)
                            Spacer()
                            Button("View all") { }
                                .font(.lcBody)
                                .foregroundStyle(Color.lcGreen)
                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.sm)

                        VStack(spacing: 0) {
                            ForEach(mockActivity) { entry in
                                ActivityRow(entry: entry)
                            }
                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.xxl)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Activity Row

private struct ActivityRow: View {
    let entry: ActivityEntry

    var body: some View {
        HStack(spacing: LCSpacing.sm) {
            Circle()
                .fill(entry.iconBg)
                .frame(width: 46, height: 46)
                .overlay {
                    Image(systemName: entry.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(entry.title)
                    .font(.lcBodyBold)
                    .foregroundStyle(Color.lcText)
                Text(entry.subtitle)
                    .font(.lcCaption)
                    .foregroundStyle(Color.lcMuted)
            }

            Spacer()

            Text("+\(entry.points) pts")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, LCSpacing.xs)
                .padding(.vertical, 5)
                .background(Color.lcGreen)
                .clipShape(Capsule())
        }
        .padding(.vertical, LCSpacing.sm)
    }
}
