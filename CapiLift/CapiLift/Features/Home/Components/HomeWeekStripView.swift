import SwiftUI

struct HomeWeekStripView: View {
    @State private var days: [WeekDay] = WeekDay.mockWeek()

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.sm) {
            Text("WEEKLY ACTIVITY")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.lcMuted)
                .tracking(0.8)
                .padding(.horizontal, LCSpacing.md)

            HStack(spacing: 0) {
                ForEach(days) { day in
                    WeekDayCell(day: day)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.vertical, LCSpacing.md)
            .background(Color.lcCard)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            .padding(.horizontal, LCSpacing.md)
        }
    }
}

struct WeekDay: Identifiable {
    let id = UUID()
    let shortName: String
    var status: DayStatus

    enum DayStatus {
        case completed       // ticked — past ride done
        case today           // car icon, highlighted
        case upcoming        // grey circle
        case off             // not going
    }

    static func mockWeek() -> [WeekDay] {
        [
            WeekDay(shortName: "MON", status: .completed),
            WeekDay(shortName: "TUE", status: .completed),
            WeekDay(shortName: "WED", status: .completed),
            WeekDay(shortName: "THU", status: .today),
            WeekDay(shortName: "FRI", status: .upcoming),
            WeekDay(shortName: "SAT", status: .off),
        ]
    }
}

private struct WeekDayCell: View {
    let day: WeekDay

    private var isToday: Bool { day.status == .today }

    var body: some View {
        VStack(spacing: LCSpacing.xs) {
            Text(day.shortName)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(isToday ? Color.lcGreen : Color.lcMuted)
                .tracking(0.5)

            ZStack {
                Circle()
                    .fill(circleBackground)
                    .frame(width: 40, height: 40)
                    .overlay {
                        if day.status == .today {
                            Circle().stroke(Color.lcGreen, lineWidth: 2)
                        }
                    }

                switch day.status {
                case .completed:
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                case .today:
                    Image(systemName: "car.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.lcGreen)
                case .upcoming:
                    Circle()
                        .fill(Color.lcMuted.opacity(0.3))
                        .frame(width: 10, height: 10)
                case .off:
                    EmptyView()
                }
            }
        }
    }

    private var circleBackground: Color {
        switch day.status {
        case .completed: return Color.lcGreen
        case .today:     return Color.lcGreen.opacity(0.08)
        case .upcoming:  return Color.lcBackground
        case .off:       return Color.lcBackground
        }
    }
}
