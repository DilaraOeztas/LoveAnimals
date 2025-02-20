//
//  MainView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import SwiftUI

struct MainView: View {

    @StateObject private var authViewModel = UserAuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isUserSignedIn {
                UserHomeView()
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
