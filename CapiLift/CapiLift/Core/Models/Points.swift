//
//  Points.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import Foundation

struct PointsLedgerEntry: Codable, Identifiable {
    let id: UUID
    var points: Int
    var reason: PointReason
    var createdAt: Date

    enum PointReason: String, Codable {
        case driverBonus   = "driver_bonus"
        case passengerRide = "passenger_ride"
        case redemption    = "redemption"
    }
}

struct Reward: Codable, Identifiable {
    let id: UUID
    var name: String
    var description: String
    var pointsCost: Int
    var stock: Int?
    var isActive: Bool
}

struct LeaderboardEntry: Codable, Identifiable {
    let id: UUID
    var user: User
    var points: Int
    var rank: Int
}
