//
//  OnboardingScheduleStep.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import SwiftUI

struct OnboardingScheduleStep: View {
    @Binding var profile: OnboardingProfile
    @State private var days: [DayEntry] = []
    @State private var initialised = false

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

                // Role hint banner
                if let role = profile.role {
                    HStack(spacing: LCSpacing.xs) {
                        Image(systemName: roleIcon(role))
                            .font(.system(size: 13))
                        Text(roleBannerText(role))
                            .font(.lcCaptionBold)
                    }
                    .foregroundStyle(Color.lcGreen)
                    .padding(.horizontal, LCSpacing.md)
                    .padding(.vertical, LCSpacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.lcGreen.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                }

                VStack(spacing: LCSpacing.sm) {
                    ForEach($days) { $day in
                        DayScheduleCard(day: $day, globalRole: profile.role)
                    }
                }
            }
            .padding(.horizontal, LCSpacing.md)
        }
        .onAppear {
            guard !initialised else { return }
            initialised = true
            days = DayEntry.defaultWeek(preselectedRole: profile.role)
        }
    }

    private func roleIcon(_ role: ScheduleDay.DayRole) -> String {
        switch role {
        case .driver:    return "car.fill"
        case .passenger: return "person.fill"
        case .both:      return "arrow.2.squarepath"
        }
    }

    private func roleBannerText(_ role: ScheduleDay.DayRole) -> String {
        switch role {
        case .driver:    return "All days pre-set to Driver — change any day individually"
        case .passenger: return "All days pre-set to Passenger — change any day individually"
        case .both:      return "You selected Both — choose your role for each day"
        }
    }
}

// MARK: - DayEntry

struct DayEntry: Identifiable {
    let id = UUID()
    let name: String
    var isGoing: Bool = false
    var campus: User.Campus = .stellenbosch
    /// nil means the user must choose (used when global role is .both)
    var role: ScheduleDay.DayRole?

    static func defaultWeek(preselectedRole: ScheduleDay.DayRole?) -> [DayEntry] {
        ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"].map { day in
            // For .both, leave role nil so the user must pick per day
            let role: ScheduleDay.DayRole? = preselectedRole == .both ? nil : preselectedRole
            return DayEntry(name: day, role: role)
        }
    }
}

// MARK: - DayScheduleCard

private struct DayScheduleCard: View {
    @Binding var day: DayEntry
    let globalRole: ScheduleDay.DayRole?

    /// When global role is .both, the user must pick per day — show an error if they haven't
    var roleRequired: Bool { globalRole == .both && day.isGoing && day.role == nil }

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

            if day.isGoing {
                Divider()

                // Campus picker
                VStack(alignment: .leading, spacing: LCSpacing.xs) {
                    Text("Campus")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)

                    HStack(spacing: LCSpacing.xs) {
                        ForEach(User.Campus.allCases, id: \.self) { campus in
                            Button { day.campus = campus } label: {
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

                // Role picker — only shown when global role is .both (user must choose per day)
                if globalRole == .both {
                    VStack(alignment: .leading, spacing: LCSpacing.xs) {
                        HStack {
                            Text("I'm")
                                .font(.lcCaption)
                                .foregroundStyle(Color.lcMuted)
                            if roleRequired {
                                Text("• required")
                                    .font(.lcCaption)
                                    .foregroundStyle(Color.lcCoral)
                            }
                        }

                        HStack(spacing: LCSpacing.xs) {
                            ForEach([ScheduleDay.DayRole.driver, .passenger, .both], id: \.self) { role in
                                Button { day.role = role } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: roleIcon(role)).font(.system(size: 11))
                                        Text(roleLabel(role)).font(.lcCaptionBold)
                                    }
                                    .foregroundStyle(day.role == role ? .white : Color.lcText)
                                    .padding(.horizontal, LCSpacing.sm)
                                    .padding(.vertical, LCSpacing.xxs + 2)
                                    .background(day.role == role ? Color.lcGreen : Color.lcBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: LCRadius.pill)
                                            .stroke(
                                                roleRequired ? Color.lcCoral.opacity(0.5) :
                                                (day.role == role ? Color.clear : Color.lcBorder),
                                                lineWidth: 1
                                            )
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(LCSpacing.md)
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
        .overlay {
            if roleRequired {
                RoundedRectangle(cornerRadius: LCRadius.lg)
                    .stroke(Color.lcCoral.opacity(0.4), lineWidth: 1)
            }
        }
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        .animation(.spring(response: 0.3), value: day.isGoing)
    }

    private func roleIcon(_ role: ScheduleDay.DayRole) -> String {
        switch role {
        case .driver:    return "car.fill"
        case .passenger: return "person.fill"
        case .both:      return "arrow.2.squarepath"
        }
    }

    private func roleLabel(_ role: ScheduleDay.DayRole) -> String {
        switch role {
        case .driver:    return "Driving"
        case .passenger: return "Getting a lift"
        case .both:      return "Both"
        }
    }
}
