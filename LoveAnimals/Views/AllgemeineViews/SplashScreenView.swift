//
//  SplashScreenView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 14.02.25.
//


import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var authViewModel: UserAuthViewModel
    @State private var navigateToNextScreen = false
    @State private var scaleEffect = 0.5

    var body: some View {
        ZStack {
            if !navigateToNextScreen {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()

                Image("AppIcon3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(scaleEffect)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            self.scaleEffect = 2.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                self.navigateToNextScreen = true
                            }
                        }
                    }
            } else {
                if authViewModel.isUserSignedIn {
                    UserHomeView()
                        .transition(.move(edge: .trailing))
                } else {
                    LoginView()
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(UserAuthViewModel())
}
