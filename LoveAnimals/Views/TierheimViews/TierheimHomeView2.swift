//
//  TierheimHomeView2.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI

struct TierheimHomeView2: View {
    @State private var selectedTab = 0
    @State private var selectedAnimal: Animal? = nil
    @EnvironmentObject var animalsViewModel: AnimalsViewModel
    
    var body: some View {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    TierheimHomeView(selectedTab: $selectedTab)
                }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                NavigationStack {
                    TierEinstellenView(selectedTab: $selectedTab, animal: selectedAnimal)
                        .environmentObject(animalsViewModel)
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
                
                StatistikView()
                    .tabItem {
                        Label("Statistiken", systemImage: "chart.bar")
                    }
                    .tag(3)
                
            }
            .navigationBarBackButtonHidden(true)
        }
    
}

#Preview {
    TierheimHomeView2()
        .environmentObject(AnimalsViewModel())
        .environmentObject(UserAuthViewModel())
}
