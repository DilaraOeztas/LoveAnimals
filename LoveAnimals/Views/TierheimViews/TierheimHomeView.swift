//
//  TierheimHomeView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 20.02.25.
//

import SwiftUI

struct TierheimHomeView: View {
    @EnvironmentObject var tierheimAuthViewModel: TierheimAuthViewModel
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Willkommen in der TierheimHomeView!")
                    .font(.largeTitle)
                    .padding()

                Spacer()

                Button(action: {
                    tierheimAuthViewModel.logout()
                    navigateToLogin = true
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }

            }
            .onAppear {
                UNUserNotificationCenter.current().delegate = NotificationManager.shared
            }
        }
    }
}

#Preview {
    TierheimHomeView()
        .environmentObject(TierheimAuthViewModel())
}
