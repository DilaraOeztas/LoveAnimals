//
//  THKonto.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 05.03.25.
//

import SwiftUI

struct THKonto: View {
    
    @EnvironmentObject var tierheimAuthViewModel: TierheimAuthViewModel
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    tierheimAuthViewModel.logout()
                    navigateToLogin = true
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: 100, minHeight: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }
}

#Preview {
    THKonto()
        .environmentObject(TierheimAuthViewModel())
}
