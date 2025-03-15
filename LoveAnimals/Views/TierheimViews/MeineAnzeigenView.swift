//
//  MeineAnzeigenView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 13.03.25.
//

import SwiftUI
import FirebaseFirestore

struct MeineAnzeigenView: View {
    @EnvironmentObject var animalsViewModel: AnimalsViewModel
    @EnvironmentObject var thAuthVM: TierheimAuthViewModel
    
    @State private var eigeneTiere: [Animal] = []
    @State private var selectedAnimal: Animal?
    @State private var showEditView = false
    @State private var navigateBack = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                if eigeneTiere.isEmpty {
                    Spacer()
                    Text("Du hast noch keine Anzeigen")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(eigeneTiere, id: \.id) { animal in
                                Button(action: {
                                    selectedAnimal = animal
                                    showEditView = true
                                }) {
                                    AnimalsView(animal: animal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Meine Anzeigen")
            .onAppear {
                Task {
                    await animalsViewModel.ladeAlleTiere()
                    eigeneTiere = animalsViewModel.animals.filter { $0.tierheimID == thAuthVM.userId }
                }
            }
            .navigationDestination(isPresented: $showEditView) {
                if let selectedAnimal = selectedAnimal {
                    TierEinstellenView(navigateBack: $navigateBack, selectedTab: .constant(0), animal: selectedAnimal)
                }
            }
        }
    }
}
