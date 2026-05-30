//
//  MainTabView.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import SwiftUI

struct MainTabView: View {
    @Environment(TabSelection.self) private var tabSelection

    var body: some View {
        @Bindable var tabSelection = tabSelection
        TabView(selection: $tabSelection.selected) {
            HomeView()
                .tabItem { Label("Home",     systemImage: "house") }
                .tag(0)
            ScheduleView()
                .tabItem { Label("Schedule", systemImage: "calendar") }
                .tag(1)
            MatchListView()
                .tabItem { Label("Matches",  systemImage: "car.2") }
                .tag(2)
                .badge(2)
            ChatListView()
                .tabItem { Label("Chats",    systemImage: "bubble.left.and.bubble.right") }
                .tag(3)
            PointsView()
                .tabItem { Label("Points",   systemImage: "star") }
                .tag(4)
        }
        .tint(Color.lcGreen)
        .toolbarBackground(Color.lcCard, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
