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

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(eigeneTiere, id: \.id) { animal in
                    AnimalsView(animal: animal)
                }
            }
            .padding()
        }
        .navigationTitle("Meine Anzeigen")
        .onAppear {
            Task {
                await animalsViewModel.ladeAlleTiere()
                eigeneTiere = animalsViewModel.animals.filter { $0.tierheimID == thAuthVM.userId }
            }
        }
    }
}
