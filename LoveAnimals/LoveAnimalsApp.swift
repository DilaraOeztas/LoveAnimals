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
    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
        .environmentObject(authViewModel)
    }
    
    init() {
        FirebaseApp.configure()
    }
    
}
