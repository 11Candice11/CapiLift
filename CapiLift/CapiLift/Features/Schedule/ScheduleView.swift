//
//  ScheduleView.swift
//  CapiLift
//

import SwiftUI

// MARK: - Day schedule model

struct DaySchedule: Identifiable {
    let id = UUID()
    let weekday: String
    let dayNumber: Int
    var isActive: Bool
    var hasCommute: Bool
    var location: String
    var campus: User.Campus
    var departureTime: Date
    var isDriving: Bool
}

// MARK: - View

struct ScheduleView: View {
    @Environment(AuthState.self) private var authState

    @State private var selectedIndex: Int = 0
    @State private var days: [DaySchedule] = Self.buildWeek()
    @State private var saved = false
    @State private var showNotifications = false

    private static func buildWeek() -> [DaySchedule] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!

        let names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let commuteDays: Set<Int> = [0, 1, 3]

        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: monday)!
            let num  = calendar.component(.day, from: date)
            let isWeekday  = offset < 5
            let hasCommute = commuteDays.contains(offset)
            let dep = calendar.date(bySettingHour: 8, minute: 30, second: 0, of: date)!
            return DaySchedule(
                weekday: names[offset],
                dayNumber: num,
                isActive: isWeekday,
                hasCommute: hasCommute,
                location: hasCommute ? "San Francisco Downtown" : "",
                campus: .stellenbosch,
                departureTime: dep,
                isDriving: false
            )
        }
    }

    var selectedDay: DaySchedule { days[selectedIndex] }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lcBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        // ── Header ───────────────────────────────────
                        HStack {
                            HStack(spacing: LCSpacing.sm) {
                                Circle()
                                    .fill(Color.lcGreen.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 18))
                                            .foregroundStyle(Color.lcGreen)
                                    }
                                Text("CapiLift")
                                    .font(.lcTitle2)
                                    .foregroundStyle(Color.lcGreen)
                            }
                            Spacer()
                            Button { showNotifications = true } label: {
                                Image(systemName: "bell")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color.lcText)
                            }
                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.top, LCSpacing.md)
                        .padding(.bottom, LCSpacing.sm)
                        .sheet(isPresented: $showNotifications) {
                            NotificationsView()
                        }

                        // ── Title ────────────────────────────────────
                        VStack(alignment: .leading, spacing: LCSpacing.xs) {
                            Text("Weekly Schedule")
                                .font(.lcTitle)
                                .foregroundStyle(Color.lcText)
                            Text("Plan your commutes for the upcoming week.")
                                .font(.lcCallout)
                                .foregroundStyle(Color.lcMuted)
                        }
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.lg)

                        // ── Day strip ────────────────────────────────
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: LCSpacing.sm) {
                                ForEach(days.indices, id: \.self) { i in
                                    DayChip(
                                        day: days[i],
                                        isSelected: selectedIndex == i
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedIndex = i
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, LCSpacing.md)
                        }
                        .padding(.bottom, LCSpacing.lg)

                        // ── Settings card ────────────────────────────
                        DaySettingsCard(
                            day: $days[selectedIndex],
                            onSave: {
                                withAnimation { saved = true }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                    withAnimation { saved = false }
                                }
                            }
                        )
                        .padding(.horizontal, LCSpacing.md)
                        .padding(.bottom, LCSpacing.md)

                        // ── Summary card ─────────────────────────────
                        SummaryCard(day: selectedDay)
                            .padding(.horizontal, LCSpacing.md)
                            .padding(.bottom, LCSpacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .bottom) {
                if saved {
                    HStack(spacing: LCSpacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Schedule saved!")
                            .font(.lcBodyBold)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, LCSpacing.lg)
                    .padding(.vertical, LCSpacing.sm)
                    .background(Color.lcGreen)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                    .shadow(color: Color.lcGreen.opacity(0.4), radius: 12, x: 0, y: 4)
                    .padding(.bottom, LCSpacing.xl)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
}

// MARK: - Day chip

private struct DayChip: View {
    let day: DaySchedule
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(day.weekday)
                    .font(.lcCaption)
                    .foregroundStyle(isSelected ? .white : Color.lcMuted)
                Text("\(day.dayNumber)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(isSelected ? .white : Color.lcText)
                Circle()
                    .fill(isSelected ? .white.opacity(0.8) : Color.lcAccent)
                    .frame(width: 5, height: 5)
                    .opacity(day.hasCommute ? 1 : 0)
            }
            .frame(width: 52, height: 70)
            .background(isSelected ? Color.lcAccent : Color.lcCard)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
            .overlay {
                if !isSelected {
                    RoundedRectangle(cornerRadius: LCRadius.md)
                        .stroke(day.hasCommute ? Color.lcAccent.opacity(0.4) : Color.lcBorder, lineWidth: 1)
                }
            }
            .shadow(color: isSelected ? Color.lcAccent.opacity(0.3) : .black.opacity(0.04),
                    radius: isSelected ? 8 : 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Day settings card

private struct DaySettingsCard: View {
    @Binding var day: DaySchedule
    let onSave: () -> Void

    @State private var showTimePicker = false

    private var fullDayName: String {
        switch day.weekday {
        case "Mon": return "Monday"
        case "Tue": return "Tuesday"
        case "Wed": return "Wednesday"
        case "Thu": return "Thursday"
        case "Fri": return "Friday"
        case "Sat": return "Saturday"
        default:    return "Sunday"
        }
    }

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        return f.string(from: day.departureTime)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.lg) {

            // Card header
            HStack(alignment: .top) {
                Text("\(fullDayName) Settings")
                    .font(.lcTitle3)
                    .foregroundStyle(Color.lcText)
                Spacer()
                if day.hasCommute {
                    Text("COMMUTE ACTIVE")
                        .font(.lcCaptionBold)
                        .foregroundStyle(Color.lcAccent)
                        .padding(.horizontal, LCSpacing.sm)
                        .padding(.vertical, LCSpacing.xxs + 2)
                        .background(Color.lcAccent.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                }
            }

            if !day.isActive {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Enable this day")
                            .font(.lcBodyBold)
                            .foregroundStyle(Color.lcText)
                        Text("Turn on to set a schedule for this day")
                            .font(.lcCaption)
                            .foregroundStyle(Color.lcMuted)
                    }
                    Spacer()
                    Toggle("", isOn: $day.isActive)
                        .tint(Color.lcGreen)
                        .labelsHidden()
                }
                .padding(LCSpacing.md)
                .background(Color.lcBackground)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
            }

            if day.isActive {
                ScheduleField(label: "Home Location", icon: "location.fill", iconColor: Color.lcMuted) {
                    TextField("e.g. 123 Maple Ave, Downtown", text: $day.location)
                        .font(.lcBody)
                        .foregroundStyle(Color.lcText)
                }

                ScheduleField(label: "Campus", icon: "building.2.fill", iconColor: Color.lcMuted) {
                    Picker("", selection: $day.campus) {
                        ForEach(User.Campus.allCases, id: \.self) { campus in
                            Text(campus.displayName).tag(campus)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color.lcText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                ScheduleField(label: "Departure Time", icon: "clock.fill", iconColor: Color.lcMuted) {
                    Button {
                        showTimePicker.toggle()
                    } label: {
                        Text(timeString)
                            .font(.lcBody)
                            .foregroundStyle(Color.lcText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                if showTimePicker {
                    DatePicker("", selection: $day.departureTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                // Driving toggle
                HStack(spacing: LCSpacing.sm) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.lcMuted)
                        .frame(width: 20)
                    Text("I am driving")
                        .font(.lcBody)
                        .foregroundStyle(Color.lcText)
                    Spacer()
                    Toggle("", isOn: $day.isDriving)
                        .tint(Color.lcGreen)
                        .labelsHidden()
                }
                .padding(.horizontal, LCSpacing.md)
                .padding(.vertical, LCSpacing.sm + 2)
                .background(Color.lcBackground)
                .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
                .overlay {
                    RoundedRectangle(cornerRadius: LCRadius.md)
                        .stroke(Color.lcBorder, lineWidth: 1)
                }

                // Map preview
                ZStack(alignment: .bottom) {
                    LinearGradient(
                        colors: [Color(hex: "1C2B3A"), Color(hex: "2D3E50"), Color(hex: "1C2B3A")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                    .overlay {
                        Image(systemName: "location.north.fill")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundStyle(.white.opacity(0.75))
                    }

                    HStack(spacing: LCSpacing.xxs) {
                        Circle()
                            .fill(Color.lcAccent)
                            .frame(width: 8, height: 8)
                        Text("45 min commute expected")
                            .font(.lcCaption)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, LCSpacing.sm)
                    .padding(.vertical, LCSpacing.xxs + 2)
                    .background(.black.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: LCRadius.pill))
                    .padding(.bottom, LCSpacing.sm)
                }

                // Save button
                Button {
                    day.hasCommute = true
                    onSave()
                } label: {
                    Text("Save Schedule")
                        .font(.lcBodyBold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LCSpacing.md)
                        .background(Color.lcGreen)
                        .clipShape(RoundedRectangle(cornerRadius: LCRadius.lg))
                }

                VStack(spacing: 2) {
                    Text("Changes will apply to next week only.")
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcMuted)
                    Button("Set as recurring?") { }
                        .font(.lcCaption)
                        .foregroundStyle(Color.lcGreen)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(LCSpacing.md)
        .padding(.leading, LCSpacing.sm)
        .background {
            HStack(spacing: 0) {
                Color.lcAccent
                    .frame(width: 4)
                Color.lcCard
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        .animation(.spring(response: 0.3), value: day.isActive)
        .animation(.spring(response: 0.3), value: showTimePicker)
    }
}

// MARK: - Summary card

private struct SummaryCard: View {
    let day: DaySchedule

    private var upperDayName: String {
        switch day.weekday {
        case "Mon": return "MONDAY"
        case "Tue": return "TUESDAY"
        case "Wed": return "WEDNESDAY"
        case "Thu": return "THURSDAY"
        case "Fri": return "FRIDAY"
        case "Sat": return "SATURDAY"
        default:    return "SUNDAY"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.md) {
            Text("\(upperDayName) SUMMARY")
                .font(.lcCaptionBold)
                .foregroundStyle(Color.lcGreen)

            VStack(spacing: LCSpacing.sm) {
                SummaryRow(label: "Potential Matches", value: "12 Members", valueColor: Color.lcText)
                SummaryRow(label: "Fuel Savings",      value: "~$8.40",      valueColor: Color.lcAccent)
                SummaryRow(label: "Carbon Reduced",    value: "1.2kg CO2",   valueColor: Color.lcAccent)
            }
        }
        .padding(LCSpacing.md)
        .background(Color.lcCard)
        .clipShape(RoundedRectangle(cornerRadius: LCRadius.xl))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

private struct SummaryRow: View {
    let label: String
    let value: String
    let valueColor: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.lcBody)
                .foregroundStyle(Color.lcText)
            Spacer()
            Text(value)
                .font(.lcBodyBold)
                .foregroundStyle(valueColor)
        }
    }
}

// MARK: - Schedule field

private struct ScheduleField<Content: View>: View {
    let label: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.xs) {
            Text(label)
                .font(.lcCaptionBold)
                .foregroundStyle(Color.lcMuted)

            HStack(spacing: LCSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
                    .frame(width: 20)

                content()
            }
            .padding(.horizontal, LCSpacing.md)
            .padding(.vertical, LCSpacing.sm + 2)
            .background(Color.lcBackground)
            .clipShape(RoundedRectangle(cornerRadius: LCRadius.md))
            .overlay {
                RoundedRectangle(cornerRadius: LCRadius.md)
                    .stroke(Color.lcBorder, lineWidth: 1)
            }
        }
    }
}
