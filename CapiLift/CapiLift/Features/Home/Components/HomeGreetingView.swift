//
//  HomeGreetingView.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct HomeGreetingView: View {
    @Environment(AuthState.self) private var authState

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        default:      return "Good evening"
        }
    }

    private var greetingEmoji: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:  return "👋"
        case 12..<17: return "☀️"
        default:      return "🌙"
        }
    }

    private var firstName: String {
        authState.currentUser?.fullName.components(separatedBy: " ").first ?? "there"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: LCSpacing.xs) {
            HStack(spacing: LCSpacing.xs) {
                Text("\(greeting), \(firstName)!")
                    .font(.lcTitle)
                    .foregroundStyle(Color.lcText)
                Text(greetingEmoji)
                    .font(.lcTitle)
            }
            Text("Ready for your green commute today?")
                .font(.lcCallout)
                .foregroundStyle(Color.lcMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, LCSpacing.md)
    }
}
