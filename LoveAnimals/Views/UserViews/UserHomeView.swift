//
//  HomeView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import SwiftUI

struct UserHomeView: View {
    @EnvironmentObject var userAuthVM: UserAuthViewModel
    @StateObject private var viewModel = AnimalsViewModel()

    @State private var searchText = ""
    @State private var profileImage: UIImage? = UIImage(named: "Dilara.jpeg")
//    @Binding var selectedTab: Int
    @State private var selectedAnimal: Animal?
    @State private var showDetailView = false

    @State private var selectedCategory: String = "Alle"
    @State private var otherCategories: [String] = []
    @State private var showBackgroundOverlay = false
    @State private var showMenu = false
    @State private var menuPosition: CGPoint = .zero
    @State private var navigateToLogin = false
    @State private var selectedOtherCategory: String? = nil
    @State private var showOtherCategories = false

    let userCoordinates: (latitude: Double, longitude: Double)?

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Image("AppIcon3")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .padding(.top, 16)
                    
                    HeaderView(profileImage: profileImage, searchText: $searchText, showBackgroundOverlay: $showBackgroundOverlay, showMenu: $showMenu, menuPosition: $menuPosition)
                    
                    HStack(spacing: 10) {
                        filterButton(title: "Alle", category: "Alle")
                        filterButton(title: "Hunde", category: "Hund")
                        filterButton(title: "Katzen", category: "Katze")
                        
                        Button(action: {
                            
                            if selectedCategory == "Weitere Tiere" {
                                showOtherCategories.toggle()
                            } else {
                                selectedCategory = "Weitere Tiere"
                                showOtherCategories = true
                            }
                           
                        }) {
                            Text("Weitere Tiere")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(selectedCategory == "Weitere Tiere" ? Color.customLightBrown : Color.gray.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    if showOtherCategories {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Wähle eine Tierart:")
                                    .font(.headline)
                                    .padding(.top, 10)
                                
                                LazyVStack(alignment: .leading, spacing: 8) {
                                    ForEach(detectOtherCategories(), id: \.self) { tierart in
                                        Button(action: {
                                            selectedOtherCategory = tierart
                                            showOtherCategories = false
                                            selectedCategory = "Weitere Tiere"
                                        }) {
                                            Text(tierart)
                                                .padding()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(filteredAnimals()) { animal in
                                    Button {
                                        selectedAnimal = animal
                                        showDetailView = true
                                    } label: {
                                        AnimalsView(animal: animal)
                                            .foregroundStyle(.primary)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationDestination(isPresented: $showDetailView) {
                    if let animal = selectedAnimal {
                        UserAnimalDetailView(animal: animal)
                    }
                }
                .onAppear {
                    UNUserNotificationCenter.current().delegate = NotificationManager.shared
                    NotificationManager.shared.requestPermission()
                }
            }
            if showMenu {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showBackgroundOverlay = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                showMenu = false
                            }
                        }
                    }
                
                VStack(alignment: .leading, spacing: 10) {
                    MenuButton(title: "Profil", systemImage: "person.circle") { }
                    MenuButton(title: "Einstellungen", systemImage: "gearshape") { }
                    MenuButton(title: "Benachrichtigungen", systemImage: "bell") { }
                    MenuButton(title: "App bewerten", systemImage: "star") { }
                    MenuButton(title: "Hilfebereich", systemImage: "questionmark.circle") { }
                    MenuButton(title: "Kontaktiere uns", systemImage: "envelope") { }
                    Divider()
                    MenuButton(title: "Ausloggen", systemImage: "rectangle.portrait.and.arrow.right", isDestructive: true) {
                        userAuthVM.logout()
                        navigateToLogin = true
                    }
                }
                .frame(width: 230)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 10)
                .position(x: menuPosition.x - 100, y: menuPosition.y + 180)
                .transition(.opacity)
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
                .foregroundStyle(.white)
                .cornerRadius(8)
        }
    }

    private func filteredAnimals() -> [Animal] {
        if selectedCategory == "Alle" {
            return viewModel.animals
        } else if selectedCategory == "Weitere Tiere" {
            if let selectedOtherCategory = selectedOtherCategory {
                return viewModel.animals.filter { $0.tierart == selectedOtherCategory }
            } else {
                return []
            }
        } else {
            return viewModel.animals.filter { $0.tierart == selectedCategory }
        }
    }
    
    private func detectOtherCategories() -> [String] {
        let allCategories = Set(viewModel.animals.map { $0.tierart })
        let excluded = ["Hund", "Katze"]
        let otherCategories = allCategories.filter { !excluded.contains($0) }
        return Array(otherCategories)
    }
    
    struct MenuButton: View {
        var title: String
        var systemImage: String
        var isDestructive: Bool = false
        var action: () -> Void

        var body: some View {
            Button(action: {
                action()
            }) {
                HStack {
                    Image(systemName: systemImage)
                        .foregroundStyle(isDestructive ? .red : .primary)
                    Text(title)
                        .foregroundStyle(isDestructive ? .red : .primary)
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    UserHomeView(userCoordinates: (latitude: 50.1109, longitude: 8.6821))
        .environmentObject(UserAuthViewModel())
        .environmentObject(AnimalsViewModel())
}
