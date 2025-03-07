//
//  TierheimHomeView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 20.02.25.
//

import SwiftUI

struct TierheimHomeView: View {
    @EnvironmentObject var tierheimAuthViewModel: TierheimAuthViewModel
    @EnvironmentObject var userAuthVM: UserAuthViewModel
    @StateObject private var viewModel = AnimalsViewModel()
    
    @State private var navigateToLogin = false
    @State private var searchText = ""
    @State private var profileImage: UIImage? = UIImage(named: "Dilara.jpeg")
    
    let userCoordinates: (latitude: Double, longitude: Double)?
    
    var body: some View {
        VStack {
            Image("AppIcon3")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.top, 16)
            
            HeaderView(profileImage: profileImage, searchText: $searchText)
            
            
            ScrollView {
                HStack(spacing: 16) {
                    ForEach(viewModel.animals) { animal in
                        AnimalsView(animal: animal, userCoordinates: userAuthVM.userCoordinates)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            
            
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
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
            
        }
        .onAppear {
            UNUserNotificationCenter.current().delegate = NotificationManager.shared
        }
        
    }
    
}




#Preview {
    TierheimHomeView(userCoordinates: (latitude: 50.1109, longitude: 8.6821))
        .environmentObject(UserAuthViewModel())
        .environmentObject(TierheimAuthViewModel())
        .environmentObject(AnimalsViewModel())
}
