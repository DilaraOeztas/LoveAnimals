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
                NavigationStack {
                    TierheimHomeView(userCoordinates: (latitude: 50.1109, longitude: 8.6821))
                }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                NavigationStack {
                    TierEinstellenView(selectedTab: $selectedTab)
                }
                    .tabItem {
                        Label("Tier einstellen", systemImage: "plus.circle")
                    }
                    .tag(1)
                
                ChatsView()
                    .tabItem {
                        Label("Chats", systemImage: "bubble.left.and.bubble.right")
                    }
                    .tag(2)
                
                THKonto()
                    .tabItem {
                        Label("Konto", systemImage: "person.crop.circle")
                    }
                    .tag(3)
                
            }
            .navigationBarBackButtonHidden(true)
        }
    
}

#Preview {
    TierheimHomeView2()
        .environmentObject(UserAuthViewModel())
}
