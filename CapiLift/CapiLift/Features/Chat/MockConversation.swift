//
//  MockConversation.swift
//  CapiLift
//

import Foundation

struct MockConversation: Identifiable {
    let id = UUID()
    var name: String
    var carInfo: String          // e.g. "Tesla Model 3"
    var lastMessage: String
    var timeString: String
    var unreadCount: Int
    var isOnline: Bool
    var hasVerified: Bool        // checkmark badge
    var tag: ConvoTag?           // optional pill tag

    enum ConvoTag {
        case points(Int)         // "+15" gold pill
        case matches             // "Matches" grey pill
    }

    static func mockList() -> [MockConversation] {
        [
            MockConversation(
                name: "Alex Rivera",
                carInfo: "Tesla Model 3",
                lastMessage: "Are we still on for the 8:00 AM commute tomorrow?",
                timeString: "2m ago",
                unreadCount: 1,
                isOnline: true,
                hasVerified: false,
                tag: .points(15)
            ),
            MockConversation(
                name: "Sarah Jenkins",
                carInfo: "Honda Civic",
                lastMessage: "Thanks for the smooth ride today! Sent the points over.",
                timeString: "1h ago",
                unreadCount: 0,
                isOnline: false,
                hasVerified: true,
                tag: nil
            ),
            MockConversation(
                name: "Marcus Thorne",
                carInfo: "BMW 3 Series",
                lastMessage: "I'll be at the North Entrance pickup point at 5:30.",
                timeString: "3h ago",
                unreadCount: 0,
                isOnline: true,
                hasVerified: false,
                tag: .matches
            ),
            MockConversation(
                name: "Elena Kostic",
                carInfo: "VW Golf",
                lastMessage: "Great, see you then!",
                timeString: "Yesterday",
                unreadCount: 0,
                isOnline: false,
                hasVerified: false,
                tag: nil
            ),
        ]
    }
}
