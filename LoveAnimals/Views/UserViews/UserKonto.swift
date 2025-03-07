//
//  UserKonto.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 05.03.25.
//

import SwiftUI

struct UserKonto: View {
    
    @EnvironmentObject var tierheimVM: TierheimAuthViewModel
    @State private var navigateToLogin: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    tierheimVM.logout()
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
    UserKonto()
        .environmentObject(TierheimAuthViewModel())

}
