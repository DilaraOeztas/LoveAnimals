//
//  HomeView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Willkommen in der HomeView!")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    authViewModel.logout()
                    navigateToLogin = true
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
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
    }
}
#Preview {
    HomeView()
}
