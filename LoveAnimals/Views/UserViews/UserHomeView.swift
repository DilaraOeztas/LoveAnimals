//
//  HomeView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import SwiftUI

struct UserHomeView: View {
    @EnvironmentObject var tierheimVM: TierheimAuthViewModel
    @EnvironmentObject var userAuthVM: UserAuthViewModel
    @StateObject private var viewModel = AnimalsViewModel()
    
    @State private var searchText = ""
    @State private var profileImage: UIImage? = UIImage(named: "Dilara.jpeg")
    
    @State private var navigateToLogin: Bool = false
    
    let userCoordinates: (latitude: Double, longitude: Double)?
    
    var body: some View {
        NavigationStack {
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
                            NavigationLink(destination: AnimalDetailView(animal: animal)) {
                                AnimalsView(animal: animal, userCoordinates: userAuthVM.userCoordinates)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    
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
                    .navigationDestination(isPresented: $navigateToLogin) {
                        LoginView()
                    }
                }
            }
            .onAppear {
                UNUserNotificationCenter.current().delegate = NotificationManager.shared
            }
//            .navigationTitle("Alle Tiere")
        }
    }
}

#Preview {
    UserHomeView(userCoordinates: (latitude: 50.1109, longitude: 8.6821))
        .environmentObject(UserAuthViewModel())
        .environmentObject(TierheimAuthViewModel())
        .environmentObject(AnimalsViewModel())
}
