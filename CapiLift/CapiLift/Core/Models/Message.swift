//
//  Message.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import Foundation

struct Message: Codable, Identifiable {
    let id: UUID
    var matchId: UUID
    var sender: User
    var content: String
    var sentAt: Date
    var isRead: Bool
}
