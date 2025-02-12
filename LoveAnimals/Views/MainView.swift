//
//  MainView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isUserSignedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel)
    }
    
}

#Preview {
    MainView()
}
