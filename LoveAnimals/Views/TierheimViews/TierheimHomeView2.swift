//
//  TierheimHomeView2.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI

struct TierheimHomeView2: View {
    var body: some View {
        TabView {
            TierheimHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            TierEinstellenView()
                .tabItem {
                    Label("Tier einstellen", systemImage: "plus.circle")
                }

            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }

            ChatsView()
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right")
                }

            SettingsView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gearshape")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TierheimHomeView2()
}
