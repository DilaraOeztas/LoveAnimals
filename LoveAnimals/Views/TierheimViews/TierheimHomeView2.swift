//
//  TierheimHomeView2.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI

struct TierheimHomeView2: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            TierheimHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            TierEinstellenView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Tier einstellen", systemImage: "plus.circle")
                }
                .tag(1)

            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }
                .tag(2)

            ChatsView()
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right")
                }
                .tag(3)

            THSettingsView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gearshape")
                }
                .tag(4)

        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TierheimHomeView2()
}
