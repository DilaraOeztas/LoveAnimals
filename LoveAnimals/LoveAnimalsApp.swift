//
//  LoveAnimalsApp.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI
import Firebase

@main
struct TierheimApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if let user = authViewModel.fireUser {
                if user.hasCompletedProfile {
                    HomeView()
                } else {
                    UserDetailsView()
                }
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel)
    }
    
    init() {
        FirebaseApp.configure()
    }
    
}
