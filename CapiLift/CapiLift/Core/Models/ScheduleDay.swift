//
//  ScheduleDay.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import Foundation

struct ScheduleDay: Codable, Identifiable {
    let id: UUID
    var date: Date
    var isGoing: Bool
    var campus: User.Campus?
    var role: DayRole?

    enum DayRole: String, Codable {
        case driver    = "driver"
        case passenger = "passenger"
        case both      = "both"
    }
}

struct WeekSchedule: Codable {
    var weekStart: Date
    var days: [ScheduleDay]
}
