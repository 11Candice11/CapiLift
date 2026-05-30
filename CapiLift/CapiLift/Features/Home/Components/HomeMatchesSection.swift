import SwiftUI
import MapKit

struct HomeMatchesSection: View {
    @State private var selectedMatch: MockMatch? = nil

    private let nextRide: MockMatch = .sarah          // David Chen, 08:15 AM
    private let newMatchCount: Int = 12
    private let featuredMatches: [MockMatch] = [.david, .marcus]

    var body: some View {
        VStack(spacing: LCSpacing.lg) {
            NextRideCard(match: nextRide)
                .onTapGesture { selectedMatch = nextRide }

            DailyMatchesBanner(count: newMatchCount, matches: featuredMatches) {
                selectedMatch = featuredMatches.first
            }

            // Leaderboard teaser
            LeaderboardTeaser()
        }
        .navigationDestination(item: $selectedMatch) { match in
            MatchDetailView(match: match)
        }
    }
}

// MARK: - Next Ride Card

private struct NextRideCard: View {
    let match: MockMatch

    @State private var mapPosition: MapCameraPosition = .automatic

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Top pill + time ──────────────────────────────────────
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: LCSpacing.xxs) {
                    Text("Next Ride")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.lcGreen)
                        .padding(.horizontal, LCSpacing.xs)
                        .padding(.vertical, 3)
                        .background(Color.lcGreen.opacity(0.1))
                        .clipShape(Capsule())

                    Text("Morning Carpool to\nTech Park")
                        .font(.lcTitle2)
                        .foregroundStyle(Color.lcText)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(match.pickupTime)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.lcText)
                    Text("Tomorrow,\nOct 12")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)
                        .multilineTextAlignment(.trailing)

                    HStack(spacing: 3) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(Color.lcSecondary)
                        Text("SAVE \(match.co2Saved, specifier: "%.1f")kg CO2")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Color.lcSecondary)
                    }
                    .padding(.top, LCSpacing.xxs)
                }
            }
            .padding(LCSpacing.md)

            // ── Map ──────────────────────────────────────────────────
            Map(position: $mapPosition) {
                Annotation("", coordinate: match.driverCoordinate) {
                    ZStack {
                        Circle()
                            .fill(Color.lcGreen.opacity(0.2))
                            .frame(width: 36, height: 36)
                        Image(systemName: "car.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.lcGreen)
                    }
                }
                Annotation("", coordinate: match.campusCoordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.lcSecondary)
                }
            }
            .frame(height: 160)
            .allowsHitTesting(false)
            .overlay(alignment: .bottomLeading) {
                HStack(spacing: LCSpacing.xs) {
                    Image(systemName: "location.north.line.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.lcGreen)
                    Text("\(match.estimatedDurationMins) mins remaining")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.lcText)
                }
                .padding(.horizontal, LCSpacing.sm)
                .padding(.vertical, LCSpacing.xxs + 2)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(LCSpacing.sm)
            }
            .onAppear {
                mapPosition = .region(MKCoordinateRegion(
                    center: match.driverCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }

            // ── Driver info ──────────────────────────────────────────
            VStack(spacing: LCSpacing.sm) {
                HStack(spacing: LCSpacing.md) {
                    // Avatar
                    Circle()
                        .fill(Color.lcGreen.opacity(0.15))
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.lcGreen)
                        }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(match.driverName)
                            .font(.lcBodyBold)
                            .foregroundStyle(Color.lcText)
                        Text(match.carDescription)
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }

                    Spacer()

                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.lcSecondary)
                        Text(String(format: "%.1f", match.driverRating))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.lcText)
                    }
                }

                // Pickup + note rows
                VStack(spacing: LCSpacing.xs) {
                    HStack(spacing: LCSpacing.sm) {
                        Image(systemName: "mappin")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.lcMuted)
                            .frame(width: 18)
                        Text(match.pickupLocation)
                            .font(.lcCallout)
                            .foregroundStyle(Color.lcText)
                        Spacer()
                    }
                    HStack(spacing: LCSpacing.sm) {
                        Image(systemName: "clock")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.lcMuted)
                            .frame(width: 18)
                        Text("Wait at the cafe entrance.")
                            .font(.lcCallout)
                            .foregroundStyle(Color.lcMuted)
                        Spacer()
                    }
                }

                // Message Driver button
                HStack(spacing: LCSpacing.sm) {
                    NavigationLink(destination: ChatView(match: match)) {
                        HStack(spacing: LCSpacing.xs) {
                            Image(systemName: "bubble.left.fill")
                                .font(.system(size: 14))
                            Text("Message Driver")
                                .font(.lcBodyBold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.sm + 2)
                        .background(Color.lcGreen)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                    }

                    Button {} label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.lcText)
                            .frame(width: 44, height: 44)
                            .background(Color.lcBackground)
                            .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                            .overlay {
                                RoundedRectangle(cornerRadius: LCRadius.md)
                                    .stroke(Color.lcBorder, lineWidth: 1)
                            }
                    }
                }
            }
            .padding(LCSpacing.md)
        }
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
        .shadow(color: .black.opacity(0.07), radius: 16, x: 0, y: 4)
        .padding(.horizontal, LCSpacing.md)
    }
}

// MARK: - Daily Matches Banner

private struct DailyMatchesBanner: View {
    let count: Int
    let matches: [MockMatch]
    let onViewAll: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.md) {
            // Title row
            HStack {
                Text("DAILY MATCHES")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white.opacity(0.7))
                    .tracking(0.8)
                Spacer()
                // Stacked avatars + count
                HStack(spacing: -10) {
                    ForEach(0..<min(3, matches.count), id: \.self) { _ in
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 28, height: 28)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .overlay { Circle().stroke(Color.lcGreen, lineWidth: 2) }
                    }
                    Text("+\(max(0, count - 3))")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .overlay { Circle().stroke(Color.lcGreen, lineWidth: 2) }
                        .offset(x: -6)
                }

                Text("\(count) New Matches")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, LCSpacing.sm)
                    .padding(.vertical, LCSpacing.xxs + 2)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
            }

            Text("We found 3 drivers heading your way at 5:00 PM today.")
                .font(.lcCallout)
                .foregroundStyle(.white.opacity(0.85))
                .lineSpacing(3)

            Button(action: onViewAll) {
                NavigationLink(destination: MatchListView(embeddedInStack: true)) {
                    Text("View Matches")
                        .font(.lcBodyBold)
                        .foregroundStyle(Color.lcGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.sm + 2)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                }
            }
        }
        .padding(LCSpacing.lg)
        .background(Color.lcGreen)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
        .shadow(color: Color.lcGreen.opacity(0.3), radius: 16, x: 0, y: 6)
        .padding(.horizontal, LCSpacing.md)
    }
}

// MARK: - Leaderboard Teaser

private struct LeaderboardTeaser: View {
    private let entries: [(rank: Int, name: String, points: Int)] = [
        (1, "Elena M.", 2450),
        (2, "Marcus K.", 2100),
        (3, "Sarah J.", 1890),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.md) {
            HStack {
                Text("Leaderboard")
                    .font(.lcTitle3)
                    .foregroundStyle(Color.lcText)
                Spacer()
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.lcMuted)
            }

            VStack(spacing: 0) {
                ForEach(entries, id: \.rank) { entry in
                    HStack(spacing: LCSpacing.md) {
                        Text("\(entry.rank)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(entry.rank == 1 ? Color.lcSecondary : Color.lcMuted)
                            .frame(width: 20)

                        Circle()
                            .fill(Color.lcBackground)
                            .frame(width: 34, height: 34)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 13))
                                    .foregroundStyle(Color.lcMuted)
                            }

                        Text(entry.name)
                            .font(.lcBodyBold)
                            .foregroundStyle(Color.lcText)

                        Spacer()

                        Text("\(entry.points) pt")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.lcText)
                    }
                    .padding(.vertical, LCSpacing.sm)

                    if entry.rank < entries.count {
                        Divider().padding(.leading, 68)
                    }
                }
            }
        }
        .padding(LCSpacing.md)
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .padding(.horizontal, LCSpacing.md)
    }
}
