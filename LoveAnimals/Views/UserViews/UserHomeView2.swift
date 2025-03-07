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
            UserHomeView(userCoordinates: (latitude: 50.1109, longitude: 8.6821))
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }

            ChatsView()
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right")
                }

            UserKonto()
                .tabItem {
                    Label("Konto", systemImage: "person.circle")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    UserHomeView2()
        .environmentObject(UserAuthViewModel())
}
