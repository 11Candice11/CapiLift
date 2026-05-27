//
//  MockMatch.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import Foundation
import MapKit

struct MockMatch: Identifiable {
    let id = UUID()
    var driverName: String
    var campus: User.Campus
    var pickupTime: String
    var distanceKm: Double
    var co2Saved: Double
    var openSeats: Int
    var carDescription: String
    var licensePlate: String
    var rideDateFormatted: String
    var recurringDays: String
    var driverCoordinate: CLLocationCoordinate2D
    var campusCoordinate: CLLocationCoordinate2D
    var pendingPassengers: [MockPassenger]

    static let preview = MockMatch(
        driverName: "David Chen",
        campus: .stellenbosch,
        pickupTime: "08:15",
        distanceKm: 12.4,
        co2Saved: 4.2,
        openSeats: 3,
        carDescription: "Tesla Model 3 • White",
        licensePlate: "LFT-2024",
        rideDateFormatted: "Wednesday, Oct 24",
        recurringDays: "Mon, Wed, Fri",
        driverCoordinate: CLLocationCoordinate2D(latitude: -33.8955, longitude: 18.8321),
        campusCoordinate: CLLocationCoordinate2D(latitude: -33.9321, longitude: 18.8601),
        pendingPassengers: [
            MockPassenger(name: "David Chen",  distanceKm: 0.4,
                coordinate: CLLocationCoordinate2D(latitude: -33.910, longitude: 18.840)),
            MockPassenger(name: "Sarah Miller", distanceKm: 1.2,
                coordinate: CLLocationCoordinate2D(latitude: -33.920, longitude: 18.850)),
        ]
    )
}

struct MockPassenger: Identifiable {
    let id = UUID()
    var name: String
    var distanceKm: Double
    var coordinate: CLLocationCoordinate2D
}