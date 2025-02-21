//
//  UserHomeView2.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI

struct UserHomeView2: View {
    var body: some View {
        TabView {
            UserHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
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
    }
}
#Preview {
    UserHomeView2()
}
