//
//  OnboardingScheduleStep.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct OnboardingScheduleStep: View {
    @Binding var profile: OnboardingProfile
    @State private var days: [DayEntry] = DayEntry.defaultWeek()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LCSpacing.lg) {
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Your week")
                        .font(.lcTitle)
                        .foregroundStyle(Color.lcText)
                    Text("Which days are you going in? You can update this every week.")
                        .font(.lcCallout)
                        .foregroundStyle(Color.lcMuted)
                        .lineSpacing(4)
                }

                VStack(spacing: LCSpacing.sm) {
                    ForEach($days) { $day in
                        DayScheduleCard(day: $day)
                    }
                }
            }
            .padding(.horizontal, LCSpacing.md)
        }
    }
}

struct DayEntry: Identifiable {
    let id = UUID()
    let name: String
    var isGoing: Bool = false
    var campus: User.Campus = .stellenbosch
    var role: ScheduleDay.DayRole = .passenger

    static func defaultWeek() -> [DayEntry] {
        ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
            .map { DayEntry(name: $0) }
    }
}

private struct DayScheduleCard: View {
    @Binding var day: DayEntry

    var body: some View {
        VStack(spacing: LCSpacing.sm) {
            // Day toggle row
            HStack {
                Text(day.name)
                    .font(.lcBodyBold)
                    .foregroundStyle(day.isGoing ? Color.lcText : Color.lcMuted)
                Spacer()
                Toggle("", isOn: $day.isGoing)
                    .tint(Color.lcGreen)
                    .labelsHidden()
            }

            // Expanded pickers when going in
            if day.isGoing {
                Divider()

                // Campus picker
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Campus")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)

                    HStack(spacing: LCSpacing.xs) {
                        ForEach(User.Campus.allCases, id: \.self) { campus in
                            Button {
                                day.campus = campus
                            } label: {
                                Text(campus.displayName)
                                    .font(.lcCaptionBold)
                                    .foregroundStyle(day.campus == campus ? .white : Color.lcText)
                                    .padding(.horizontal, LCSpacing.sm)
                                    .padding(.vertical, LCSpacing.xxs + 2)
                                    .background(day.campus == campus ? Color.lcGreen : Color.lcBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: LCRadius.pill)
                                            .stroke(day.campus == campus ? Color.clear : Color.lcBorder, lineWidth: 1)
                                    }
                            }
                        }
                        Spacer()
                    }
                }

                // Role picker
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("I'm")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)

                    HStack(spacing: LCSpacing.xs) {
                        ForEach([ScheduleDay.DayRole.driver, .passenger, .both], id: \.self) { role in
                            Button {
                                day.role = role
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: role == .driver ? "car.fill" : role == .passenger ? "person.fill" : "arrow.2.squarepath")
                                        .font(.system(size: 11))
                                    Text(role == .driver ? "Driving" : role == .passenger ? "Getting a lift" : "Both")
                                        .font(.lcCaptionBold)
                                }
                                .foregroundStyle(day.role == role ? .white : Color.lcText)
                                .padding(.horizontal, LCSpacing.sm)
                                .padding(.vertical, LCSpacing.xxs + 2)
                                .background(day.role == role ? Color.lcGreen : Color.lcBackground)
                                .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                                .overlay {
                                    RoundedRectangle(cornerRadius: LCRadius.pill)
                                        .stroke(day.role == role ? Color.clear : Color.lcBorder, lineWidth: 1)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(LCSpacing.md)
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        .animation(.spring(response: 0.3), value: day.isGoing)
    }
}
