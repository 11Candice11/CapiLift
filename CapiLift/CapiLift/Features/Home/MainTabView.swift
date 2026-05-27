//
//  MainTabView.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home",    systemImage: "house.fill") }
            MatchListView()
                .tabItem { Label("Matches", systemImage: "car.2.fill") }
                .badge(2)
            ChatListView()
                .tabItem { Label("Chat",    systemImage: "bubble.left.and.bubble.right.fill") }
            PointsView()
                .tabItem { Label("Points",  systemImage: "star.fill") }
        }
        .tint(.green)
    }
}
