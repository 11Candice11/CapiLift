//
//  User.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var fullName: String
    var email: String
    var employeeId: String
    var homeAddress: String
    var homeLat: Double
    var homeLng: Double
    var campus: Campus
    var totalPoints: Int
    var profilePhotoURL: String?

    enum Campus: String, Codable, CaseIterable {
        case stellenbosch = "stellenbosch"
        case canalWalk    = "canal_walk"

        var displayName: String {
            switch self {
            case .stellenbosch: return "Stellenbosch"
            case .canalWalk:    return "Canal Walk"
            }
        }
    }
}