//
//  Match.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import Foundation

struct Match: Codable, Identifiable {
    let id: UUID
    var driver: User
    var passengers: [MatchPassenger]
    var rideDate: Date
    var campus: User.Campus
    var status: MatchStatus
    var departureTime: Date?

    enum MatchStatus: String, Codable {
        case pending   = "pending"
        case accepted  = "accepted"
        case completed = "completed"
        case cancelled = "cancelled"
    }
}

struct MatchPassenger: Codable, Identifiable {
    let id: UUID
    var user: User
    var status: PassengerStatus
    var pointsAwarded: Int?

    enum PassengerStatus: String, Codable {
        case pending  = "pending"
        case accepted = "accepted"
        case declined = "declined"
    }
}