//
//  SplashScreenView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 14.02.25.
//


import SwiftUI

struct SplashScreenView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("loggedInUsertype") private var loggedInUsertype: String = ""
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
                            withAnimation {
                                self.navigateToNextScreen = true
                            }
                            
                        }
                    }
            } else {
                if isLoggedIn {
                    if loggedInUsertype == "user" {
                        UserHomeView2()
                            .transition(.move(edge: .trailing))
                    } else if loggedInUsertype == "tierheim" {
                        TierheimHomeView2()
                            .transition(.move(edge: .trailing))
                    } else {
                        LoginView()
                            .transition(.move(edge: .trailing))
                    }
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
}






    
