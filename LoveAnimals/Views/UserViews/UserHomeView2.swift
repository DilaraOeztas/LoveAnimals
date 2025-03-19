//
//  UserHomeView2.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI

struct UserHomeView2: View {
    @EnvironmentObject var userAuthVM: UserAuthViewModel
    var body: some View {
        TabView {
            NavigationStack {
                UserHomeView()
                    .environmentObject(userAuthVM)
            }
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }

            UserChatsView()
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right")
                }

            SpendenView()
                .tabItem {
                    Label("Spenden", systemImage: "eurosign.circle")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    UserHomeView2()
        .environmentObject(UserAuthViewModel())
        .environmentObject(AnimalsViewModel())
}
