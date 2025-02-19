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
    @StateObject private var authViewModel = UserAuthViewModel()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(authViewModel)
            //MainView()
                //.dismissKeyboardOnTap()
        }
    }

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }

}
