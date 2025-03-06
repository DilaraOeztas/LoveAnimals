//
//  SettingsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: UserAuthViewModel
    @State private var navigateToLogin: Bool = false
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Spacer()
        Button(action: {
            authViewModel.logout()
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
}

#Preview {
    SettingsView()
        .environmentObject(UserAuthViewModel())
}
