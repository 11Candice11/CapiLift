//
//  MockMatch.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import Foundation
import MapKit

struct MockMatch: Identifiable, Hashable {
    let id = UUID()
    var driverName: String
    var campus: User.Campus
    var pickupTime: String
    var pickupLocation: String
    var locationLabel: String
    var destination: String
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
    var role: MatchRole
    var isCO2Saver: Bool
    var dayLabel: String
    var matchBadge: MatchBadge
    var driverRating: Double
    var estimatedDurationMins: Int

    enum MatchRole {
        case driver, passenger
    }

    enum MatchBadge: String {
        case verified = "VERIFIED"
        case regular  = "REGULAR"
        case newMatch = "NEW MATCH"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MockMatch, rhs: MockMatch) -> Bool {
        lhs.id == rhs.id
    }
}

struct MockPassenger: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var distanceKm: Double
    var coordinate: CLLocationCoordinate2D

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MockPassenger, rhs: MockPassenger) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Mock data

extension MockMatch {

    static let david = MockMatch(
        driverName: "Sarah Jenkins",
        campus: .stellenbosch,
        pickupTime: "08:30 AM",
        pickupLocation: "Somerset West",
        locationLabel: "North Campus",
        destination: "Stellenbosch Campus",
        distanceKm: 0.8,
        co2Saved: 2.9,
        openSeats: 2,
        carDescription: "Honda Civic • Red",
        licensePlate: "SMR-2023",
        rideDateFormatted: "Monday, Jun 2",
        recurringDays: "Mon, Tue, Wed, Thu, Fri",
        driverCoordinate: CLLocationCoordinate2D(latitude: -34.0800, longitude: 18.8500),
        campusCoordinate: CLLocationCoordinate2D(latitude: -33.9321, longitude: 18.8601),
        pendingPassengers: [
            MockPassenger(name: "Leila Abrams", distanceKm: 0.7,
                coordinate: CLLocationCoordinate2D(latitude: -33.875, longitude: 18.615)),
        ],
        role: .driver,
        isCO2Saver: false,
        dayLabel: "MONDAY",
        matchBadge: .verified,
        driverRating: 4.9,
        estimatedDurationMins: 45
    )

    static let sarah = MockMatch(
        driverName: "David Chen",
        campus: .stellenbosch,
        pickupTime: "09:15 AM",
        pickupLocation: "Bellville",
        locationLabel: "Downtown Hub",
        destination: "Stellenbosch Campus",
        distanceKm: 2.4,
        co2Saved: 4.2,
        openSeats: 3,
        carDescription: "Tesla Model 3 • White",
        licensePlate: "LFT-2024",
        rideDateFormatted: "Monday, Jun 2",
        recurringDays: "Mon, Wed, Fri",
        driverCoordinate: CLLocationCoordinate2D(latitude: -33.8955, longitude: 18.8321),
        campusCoordinate: CLLocationCoordinate2D(latitude: -33.9321, longitude: 18.8601),
        pendingPassengers: [
            MockPassenger(name: "Sarah Miller", distanceKm: 0.4,
                coordinate: CLLocationCoordinate2D(latitude: -33.910, longitude: 18.840)),
            MockPassenger(name: "James Okafor", distanceKm: 1.2,
                coordinate: CLLocationCoordinate2D(latitude: -33.920, longitude: 18.850)),
        ],
        role: .driver,
        isCO2Saver: true,
        dayLabel: "MONDAY",
        matchBadge: .regular,
        driverRating: 4.7,
        estimatedDurationMins: 38
    )

    static let marcus = MockMatch(
        driverName: "Elena Rodriguez",
        campus: .stellenbosch,
        pickupTime: "08:00 AM",
        pickupLocation: "Sea Point",
        locationLabel: "East Campus",
        destination: "Stellenbosch Campus",
        distanceKm: 3.1,
        co2Saved: 5.1,
        openSeats: 2,
        carDescription: "Nissan Leaf • White",
        licensePlate: "GRN-2024",
        rideDateFormatted: "Tuesday, Jun 3",
        recurringDays: "Mon, Wed, Fri",
        driverCoordinate: CLLocationCoordinate2D(latitude: -33.9180, longitude: 18.3850),
        campusCoordinate: CLLocationCoordinate2D(latitude: -33.9321, longitude: 18.8601),
        pendingPassengers: [
            MockPassenger(name: "Ruan Botha", distanceKm: 1.5,
                coordinate: CLLocationCoordinate2D(latitude: -33.967, longitude: 18.465)),
        ],
        role: .driver,
        isCO2Saver: true,
        dayLabel: "TUESDAY",
        matchBadge: .newMatch,
        driverRating: 4.8,
        estimatedDurationMins: 52
    )

    static let mike = MockMatch(
        driverName: "Chloe Smith",
        campus: .canalWalk,
        pickupTime: "08:00 AM",
        pickupLocation: "Claremont Station",
        locationLabel: "Canal Walk",
        destination: "Canal Walk Office Park",
        distanceKm: 0.5,
        co2Saved: 2.9,
        openSeats: 1,
        carDescription: "VW Golf 8 • Silver",
        licensePlate: "CWK-2023",
        rideDateFormatted: "Wednesday, Jun 4",
        recurringDays: "Tue, Thu",
        driverCoordinate: CLLocationCoordinate2D(latitude: -33.8700, longitude: 18.6100),
        campusCoordinate: CLLocationCoordinate2D(latitude: -33.8830, longitude: 18.6050),
        pendingPassengers: [
            MockPassenger(name: "Priya Naidoo", distanceKm: 0.9,
                coordinate: CLLocationCoordinate2D(latitude: -33.963, longitude: 18.468)),
        ],
        role: .driver,
        isCO2Saver: false,
        dayLabel: "WEDNESDAY",
        matchBadge: .regular,
        driverRating: 4.5,
        estimatedDurationMins: 30
    )

    static let elena = MockMatch(
        driverName: "Marco van Zyl",
        campus: .stellenbosch,
        pickupTime: "07:45 AM",
        pickupLocation: "Kenilworth",
        locationLabel: "South Campus",
        destination: "Canal Walk",
        distanceKm: 2.1,
        co2Saved: 3.6,
        openSeats: 1,
        carDescription: "Toyota Corolla Cross • Blue",
        licensePlate: "ECO-2022",
        rideDateFormatted: "Thursday, Jun 5",
        recurringDays: "Mon, Tue, Wed, Thu, Fri",
        driverCoordinate: CLLocationCoordinate2D(latitude: -33.9600, longitude: 18.4700),
        campusCoordinate: CLLocationCoordinate2D(latitude: -33.8830, longitude: 18.6050),
        pendingPassengers: [
            MockPassenger(name: "Tom Hendricks", distanceKm: 0.3,
                coordinate: CLLocationCoordinate2D(latitude: -33.958, longitude: 18.472)),
        ],
        role: .driver,
        isCO2Saver: false,
        dayLabel: "THURSDAY",
        matchBadge: .verified,
        driverRating: 4.6,
        estimatedDurationMins: 42
    )

    static let james = MockMatch(
        driverName: "James Miller",
        campus: .canalWalk,
        pickupTime: "09:00 AM",
        pickupLocation: "Bellville CBD",
        locationLabel: "West Campus",
        destination: "Canal Walk Office Park",
        distanceKm: 6.3,
        co2Saved: 2.1,
        openSeats: 0,
        carDescription: "BMW 3 Series • Black",
        licensePlate: "JMR-2025",
        rideDateFormatted: "Friday, Jun 6",
        recurringDays: "Mon, Wed",
        driverCoordinate: CLLocationCoordinate2D(latitude: -33.9249, longitude: 18.4241),
        campusCoordinate: CLLocationCoordinate2D(latitude: -33.8830, longitude: 18.6050),
        pendingPassengers: [],
        role: .passenger,
        isCO2Saver: false,
        dayLabel: "FRIDAY",
        matchBadge: .regular,
        driverRating: 4.3,
        estimatedDurationMins: 55
    )

    static let preview = david

    static let all: [MockMatch] = [david, sarah, marcus, mike, elena, james]
}
