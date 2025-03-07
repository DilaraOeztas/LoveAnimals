//
//  LoveAnimalsApp.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI
import Firebase
import UserNotifications

@main
struct LoveAnimalsApp: App {
    @AppStorage("hasRequestedNotificationPermission") private var hasRequestedNotificationPermission: Bool = false
    
    @StateObject private var authViewModel = UserAuthViewModel()
    @StateObject private var tierheimAuthViewModel = TierheimAuthViewModel()
    @StateObject private var animalsViewModel = AnimalsViewModel()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(authViewModel)
                .environmentObject(tierheimAuthViewModel)
                .environmentObject(animalsViewModel)
        }
    }

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()

    }

}
