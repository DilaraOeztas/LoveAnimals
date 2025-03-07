//
//  TierheimHomeView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 20.02.25.
//

import SwiftUI

struct TierheimHomeView: View {
    @EnvironmentObject var userAuthVM: UserAuthViewModel
    @EnvironmentObject var viewModel: AnimalsViewModel
    
    @State private var searchText = ""
    @State private var profileImage: UIImage? = UIImage(named: "Dilara.jpeg")
    @State private var selectedAnimal: Animal?
    @State private var showDetailView = false
    
    let userCoordinates: (latitude: Double, longitude: Double)?
    
    @State private var showToast = false
    @AppStorage("showPostUploadToast") var showPostUploadToast = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.animals) { animal in
                            Button {
                                selectedAnimal = animal
                                showDetailView = true
                            } label: {
                                AnimalsView(animal: animal, userCoordinates: userAuthVM.userCoordinates)
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                if showPostUploadToast {
                    showPostUploadToast = false
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showToast = false
                    }
                }
            }
            .overlay(
                toastOverlay,
                alignment: .bottom
            )
            .navigationDestination(isPresented: $showDetailView) {
                if let animal = selectedAnimal {
                    AnimalDetailView(animal: animal)
                }
            }
            .onAppear {
                UNUserNotificationCenter.current().delegate = NotificationManager.shared
            }
        }
    }
    
    @ViewBuilder
    var toastOverlay: some View {
        if showToast {
            Text("Dein Tier wird in Kürze online angezeigt!")
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundStyle(.white)
                .cornerRadius(8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: showToast)
                .padding(.bottom, 50)
        }
    }
}




#Preview {
    TierheimHomeView(userCoordinates: (latitude: 50.1109, longitude: 8.6821))
        .environmentObject(UserAuthViewModel())
        .environmentObject(AnimalsViewModel())
}
