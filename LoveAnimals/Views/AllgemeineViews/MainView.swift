//
//  MainView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import SwiftUI

struct MainView: View {

    @StateObject private var userAuthViewModel = UserAuthViewModel()
    @StateObject private var tierheimAuthViewModel = TierheimAuthViewModel()

    var body: some View {
        Group {
            if userAuthViewModel.isUserSignedIn {
                UserHomeView()
            } else {
                LoginView()
            }
        }
        .environmentObject(userAuthViewModel)
    }

}

#Preview {
    MainView()
}
