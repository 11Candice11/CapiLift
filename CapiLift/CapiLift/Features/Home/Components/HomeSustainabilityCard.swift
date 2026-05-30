import SwiftUI

struct HomeSustainabilityCard: View {
    let co2Saved: Double
    let weeklyGoalPercent: Double  // 0–1
    let streakDays: Int
    let globalRank: Int
    let co2Goal: Double

    init(
        co2Saved: Double = 12.4,
        weeklyGoalPercent: Double = 0.70,
        streakDays: Int = 12,
        globalRank: Int = 142,
        co2Goal: Double = 200
    ) {
        self.co2Saved = co2Saved
        self.weeklyGoalPercent = weeklyGoalPercent
        self.streakDays = streakDays
        self.globalRank = globalRank
        self.co2Goal = co2Goal
    }

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.lg) {

            // ── Ring + headline row ──────────────────────────────────
            HStack(alignment: .top, spacing: LCSpacing.lg) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.lcBorder, lineWidth: 10)
                        .frame(width: 110, height: 110)
                    Circle()
                        .trim(from: 0, to: weeklyGoalPercent)
                        .stroke(
                            Color.lcGreen,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 110, height: 110)
                        .animation(.spring(response: 0.8), value: weeklyGoalPercent)

                    VStack(spacing: 2) {
                        Text("\(Int(weeklyGoalPercent * 100))%")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.lcText)
                        Text("Weekly\nGoal")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color.lcMuted)
                            .multilineTextAlignment(.center)
                    }
                }

                // Right side text
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Your Commute Pulse")
                        .font(.lcTitle3)
                        .foregroundStyle(Color.lcText)

                    Text("You've saved **\(co2Saved, specifier: "%.1f")kg of CO2** this week. Only 3 more rides to reach your eco-warrior milestone!")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)

                    // Streak + rank row
                    HStack(spacing: LCSpacing.lg) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("CURRENT STREAK")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(Color.lcMuted)
                                .tracking(0.6)
                            Text("\(streakDays) Days")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color.lcSecondary)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("GLOBAL RANK")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(Color.lcMuted)
                                .tracking(0.6)
                            Text("#\(globalRank)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color.lcText)
                        }
                    }
                    .padding(.top, LCSpacing.xxs)
                }
            }

            // ── CO2 bar ──────────────────────────────────────────────
            VStack(alignment: .leading, spacing: LCSpacing.xs) {
                HStack {
                    Text("TOTAL CO2 SAVED")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.lcSecondary)
                        .tracking(0.8)
                    Spacer()
                    Text("\(co2Saved, specifier: "%.1f")kg / \(Int(co2Goal))kg")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.lcText)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.lcBorder)
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.lcSecondary)
                            .frame(width: geo.size.width * min(co2Saved / co2Goal, 1.0), height: 8)
                            .animation(.spring(response: 0.8), value: co2Saved)
                    }
                }
                .frame(height: 8)

                Text("You're in the top 5% of planet savers this month!")
                    .font(.lcCaption)
                    .foregroundStyle(Color.lcMuted)
                    .italic()
            }
        }
        .padding(LCSpacing.lg)
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 4)
        .padding(.horizontal, LCSpacing.md)
    }
}
