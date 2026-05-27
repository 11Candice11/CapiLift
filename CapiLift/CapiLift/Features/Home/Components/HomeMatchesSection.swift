import SwiftUI

struct HomeMatchesSection: View {
    @State private var selectedMatch: MockMatch? = nil
    @State private var showDetail = false

    var body: some View {
        VStack(spacing: LCSpacing.sm) {
            // Section header
            HStack {
                Text("Your Matches")
                    .font(.lcTitle2)
                    .foregroundStyle(Color.lcText)
                Spacer()
                Button("View All") {}
                    .font(.lcBodyBold)
                    .foregroundStyle(Color.lcGreen)
            }
            .padding(.horizontal, LCSpacing.md)

            Button {
                selectedMatch = MockMatch.preview
                showDetail = true
            } label: {
                MatchPreviewCard(
                    name: "David",
                    role: .driver,
                    distance: "2.4 km away",
                    timeLabel: "Leaves at 07:45",
                    passengerCount: 3
                )
            }
            .buttonStyle(.plain)

            Button {
                selectedMatch = MockMatch.preview
                showDetail = true
            } label: {
                MatchPreviewCard(
                    name: "Mike",
                    role: .passenger,
                    distance: "0.8 km away",
                    timeLabel: "Ready by 08:00",
                    passengerCount: 0
                )
            }
            .buttonStyle(.plain)
        }
        .navigationDestination(isPresented: $showDetail) {
            if let match = selectedMatch {
                MatchDetailView(match: match)
            }
        }
    }
}

private struct MatchPreviewCard: View {
    let name: String
    let role: ScheduleDay.DayRole
    let distance: String
    let timeLabel: String
    let passengerCount: Int

    var roleLabel: String { role == .driver ? "DRIVER" : "PASSENGER" }
    var roleColor: Color  { role == .driver ? Color.lcGreen : Color.lcCoral }

    var body: some View {
        VStack(spacing: LCSpacing.sm) {
            // Top row
            HStack(spacing: LCSpacing.sm) {
                // Avatar
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.lcGreen.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: "person.fill")
                        .foregroundStyle(Color.lcGreen.opacity(0.5))
                        .font(.system(size: 24))
                        .frame(width: 52, height: 52)

                    Circle()
                        .fill(roleColor)
                        .frame(width: 20, height: 20)
                        .overlay {
                            Image(systemName: role == .driver ? "car.fill" : "figure.walk")
                                .font(.system(size: 9))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 2, y: 2)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.lcTitle3)
                        .foregroundStyle(Color.lcText)
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.lcMuted)
                        Text(distance)
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }
                }

                Spacer()

                // Role badge
                Text(roleLabel)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(roleColor)
                    .padding(.horizontal, LCSpacing.sm)
                    .padding(.vertical, LCSpacing.xxs)
                    .background(roleColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
            }

            Divider()

            // Bottom row
            HStack {
                Image(systemName: role == .driver ? "clock" : "checkmark.circle")
                    .foregroundStyle(Color.lcMuted)
                    .font(.system(size: 14))
                Text(timeLabel)
                    .font(.lcCallout)
                    .foregroundStyle(Color.lcText)

                Spacer()

                if passengerCount > 0 {
                    HStack(spacing: -8) {
                        ForEach(0..<passengerCount, id: \.self) { _ in
                            Circle()
                                .fill(Color.lcGreen.opacity(0.15))
                                .frame(width: 28, height: 28)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.lcGreen.opacity(0.6))
                                }
                                .overlay {
                                    Circle().stroke(Color.lcCard, lineWidth: 2)
                                }
                        }
                    }
                }
            }
        }
        .padding(LCSpacing.md)
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .padding(.horizontal, LCSpacing.md)
    }
}
