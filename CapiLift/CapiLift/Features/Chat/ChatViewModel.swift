//
//  ChatViewModel.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import SwiftUI
import Combine

@Observable
final class ChatViewModel {
    var messages: [Message] = []
    var newMessage: String = ""
    var matchTitle: String = ""
    var matchSubtitle: String = ""
    var co2Saved: Double = 4.2
    var isGroupChat: Bool = false
    var driverLat: Double = -33.9249
    var driverLng: Double = 18.4241

    // Exposed so the view can pass it down to MessageBubble
    let currentUserId: UUID

    // The current user object, reused when sending messages
    private let currentUser: User

    init(currentUserId: UUID, match: MockMatch) {
        self.currentUserId = currentUserId
        self.currentUser = User(
            id: currentUserId,
            fullName: "You",
            email: "you@example.com",
            employeeId: "EMP999",
            homeAddress: "Claremont",
            homeLat: -33.9800,
            homeLng: 18.4650,
            campus: .stellenbosch,
            totalPoints: 420,
            profilePhotoURL: nil
        )
        self.matchTitle = match.driverName.components(separatedBy: " ").first ?? match.driverName
        self.matchSubtitle = "\(match.carDescription) • ACTIVE MATCH"
        self.co2Saved = match.co2Saved
        self.driverLat = match.driverCoordinate.latitude
        self.driverLng = match.driverCoordinate.longitude
        // Group chat when there are multiple passengers besides the driver
        self.isGroupChat = match.pendingPassengers.count > 1
        loadMockMessages(match: match)
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }

    private func loadMockMessages(match: MockMatch) {
        // Build stable participant users from the match
        let driverId = UUID()
        let driver = User(
            id: driverId,
            fullName: match.driverName,
            email: "\(match.driverName.lowercased().replacingOccurrences(of: " ", with: "."))@example.com",
            employeeId: "EMP001",
            homeAddress: "Cape Town CBD",
            homeLat: -33.9249,
            homeLng: 18.4241,
            campus: match.campus,
            totalPoints: 240,
            profilePhotoURL: nil
        )

        // Build a user per pending passenger so group chats show distinct names
        let passengerUsers: [User] = match.pendingPassengers.map { p in
            User(
                id: UUID(),
                fullName: p.name,
                email: "\(p.name.lowercased().replacingOccurrences(of: " ", with: "."))@example.com",
                employeeId: "EMP00\(Int.random(in: 2...8))",
                homeAddress: "Cape Town",
                homeLat: p.coordinate.latitude,
                homeLng: p.coordinate.longitude,
                campus: match.campus,
                totalPoints: Int.random(in: 80...300),
                profilePhotoURL: nil
            )
        }

        let matchId = UUID()

        var msgs: [Message] = [
            Message(
                id: UUID(), matchId: matchId, sender: driver,
                content: "Hey! I'm heading towards the financial district around 5:15. Does that still work for you? 🚗",
                sentAt: time(hour: 8, minute: 45), isRead: true
            ),
            Message(
                id: UUID(), matchId: matchId, sender: currentUser,
                content: "That's perfect. I'll be at the North entrance of the plaza. 🏢",
                sentAt: time(hour: 8, minute: 48), isRead: true
            ),
            Message(
                id: UUID(), matchId: matchId, sender: driver,
                content: "Great. I've just shared my live location. I'm in a \(match.carDescription), license plate \(match.licensePlate). See you soon!",
                sentAt: time(hour: 9, minute: 12), isRead: true
            ),
        ]

        // Add group chat messages if there are other passengers
        if let firstPassenger = passengerUsers.first {
            msgs.append(Message(
                id: UUID(), matchId: matchId, sender: firstPassenger,
                content: "Hey everyone! Looking forward to the ride 👋",
                sentAt: time(hour: 7, minute: 50), isRead: true
            ))
        }
        if passengerUsers.count > 1 {
            msgs.append(Message(
                id: UUID(), matchId: matchId, sender: passengerUsers[1],
                content: "Same here! Should be a good one.",
                sentAt: time(hour: 7, minute: 51), isRead: true
            ))
            msgs.append(Message(
                id: UUID(), matchId: matchId, sender: currentUser,
                content: "Morning all! See you at the pickup spot 🙌",
                sentAt: time(hour: 7, minute: 52), isRead: true
            ))
        }

        messages = msgs
    }

    func sendMessage() {
        let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let message = Message(
            id: UUID(),
            matchId: UUID(),
            sender: currentUser,   // always the real currentUser with the correct id
            content: trimmed,
            sentAt: Date(),
            isRead: false
        )

        withAnimation {
            messages.append(message)
        }

        newMessage = ""
    }

    func groupedMessages() -> [MessageGroup] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        let grouped = Dictionary(grouping: messages) { msg in
            Calendar.current.isDateInToday(msg.sentAt) ? "Today" : formatter.string(from: msg.sentAt)
        }

        return grouped.keys.sorted().map { key in
            MessageGroup(date: key, messages: grouped[key]!.sorted { $0.sentAt < $1.sentAt })
        }
    }

    private func time(hour: Int, minute: Int) -> Date {
        Calendar.current.date(
            bySettingHour: hour, minute: minute, second: 0, of: Date()
        ) ?? Date()
    }
}

struct MessageGroup: Identifiable {
    let id = UUID()
    let date: String
    let messages: [Message]
}
