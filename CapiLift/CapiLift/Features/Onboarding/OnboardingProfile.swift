//
//  OnboardingProfile.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import Foundation

struct OnboardingProfile {
    var fullName: String = ""
    var email: String = ""
    var homeAddress: String = ""
    var homeLat: Double = -34.0833
    var homeLng: Double = 18.8476
    var campus: User.Campus? = nil
    var role: ScheduleDay.DayRole? = nil
    // Car details
    var carMake: String = ""
    var carModel: String = ""
    var carColour: String = ""
    var licensePlate: String = ""
    var availableSeats: Int = 3
}
