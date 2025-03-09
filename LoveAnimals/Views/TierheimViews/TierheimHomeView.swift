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
    
    @State private var selectedCategory: String = "Alle"
    @State private var otherCategories: [String] = []
    
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
                
                HStack(spacing: 10) {
                    filterButton(title: "Alle", category: "Alle")
                    filterButton(title: "Hunde", category: "Hund")
                    filterButton(title: "Katzen", category: "Katze")
                    filterButton(title: "Weitere Tiere", category: "Weitere Tiere")
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredAnimals()) { animal in
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
    
    
    private func filterButton(title: String, category: String) -> some View {
        Button(action: { selectedCategory = category }) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(selectedCategory == category ? Color.customLightBrown : Color.gray.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }

    private func filteredAnimals() -> [Animal] {
        if selectedCategory == "Alle" {
            return viewModel.animals
        } else if selectedCategory == "Weitere Tiere" {
            return viewModel.animals.filter { otherCategories.contains($0.tierart) }
        } else {
            return viewModel.animals.filter { $0.tierart == selectedCategory }
        }
    }
    
    private func detectOtherCategories() {
        let allCategories = Set(viewModel.animals.map { $0.tierart })
        let excluded = ["Hund", "Katze"]
        otherCategories = allCategories.filter { !excluded.contains($0) }
    }
    
    
    @ViewBuilder
    var toastOverlay: some View {
        if showToast {
            Text("Dein Tier wird in Kürze online gehen!")
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
