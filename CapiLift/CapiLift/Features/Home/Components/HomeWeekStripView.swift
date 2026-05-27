//
//  HomeWeekStripView.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct HomeWeekStripView: View {
    // Mock data — will come from API later
    @State private var days: [WeekDay] = WeekDay.mockWeek()

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.sm) {
            Text("WEEKLY SCHEDULE")
                .font(.lcCaptionBold)
                .foregroundStyle(Color.lcMuted)
                .padding(.horizontal, LCSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: LCSpacing.sm) {
                    ForEach(days) { day in
                        WeekDayChip(day: day)
                    }
                }
                .padding(.horizontal, LCSpacing.md)
            }
        }
    }
}

struct WeekDay: Identifiable {
    let id = UUID()
    let name: String
    let shortName: String
    var isGoing: Bool
    var coverage: CoverageLevel

    enum CoverageLevel {
        case high, low, none

        var label: String {
            switch self {
            case .high: return "HIGH\nCOVERAGE"
            case .low:  return "LOW\nCOVERAGE"
            case .none: return ""
            }
        }

        var color: Color {
            switch self {
            case .high: return .lcGreen
            case .low:  return .lcMuted
            case .none: return .clear
            }
        }
    }

    static func mockWeek() -> [WeekDay] {
        [
            WeekDay(name: "Monday",    shortName: "Mon", isGoing: true,  coverage: .high),
            WeekDay(name: "Tuesday",   shortName: "Tue", isGoing: false, coverage: .low),
            WeekDay(name: "Wednesday", shortName: "Wed", isGoing: true,  coverage: .high),
            WeekDay(name: "Thursday",  shortName: "Thu", isGoing: false, coverage: .low),
            WeekDay(name: "Friday",    shortName: "Fri", isGoing: false, coverage: .high),
        ]
    }
}

private struct WeekDayChip: View {
    let day: WeekDay

    var body: some View {
        VStack(spacing: LCSpacing.xs) {
            Text(day.shortName)
                .font(.lcBodyBold)
                .foregroundStyle(day.isGoing ? .white : Color.lcText)
                .frame(width: 64, height: 64)
                .background(day.isGoing ? Color.lcGreen : Color.lcCard)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                .overlay {
                    RoundedRectangle(cornerRadius: LCRadius.md)
                        .stroke(day.isGoing ? Color.clear : Color.lcBorder, lineWidth: 1)
                }
                .shadow(color: .black.opacity(day.isGoing ? 0.1 : 0.04), radius: 6, x: 0, y: 2)

            Text(day.coverage.label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(day.coverage.color)
                .multilineTextAlignment(.center)
                .frame(height: 24)

            Circle()
                .fill(day.isGoing ? Color.lcGreen : Color.clear)
                .frame(width: 6, height: 6)
        }
        .frame(width: 72)
    }
}