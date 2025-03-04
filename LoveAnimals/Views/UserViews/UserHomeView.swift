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
    @State private var searchText = ""
    @State private var profileImage = UIImage(named: "Dilara.jpeg") // Platzhalter
    

    var body: some View {
        VStack {
            headerView()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tierheimVM.animals) { animal in
                        AnimalsView(animal: animal, userCoordinates: userAuthVM.userCoordinates)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                ladeProfilbild()
                userAuthVM.ladeUserKoordinaten()
                tierheimVM.ladeTiereAusTierheimen()
            }
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Image(uiImage: profileImage ?? UIImage(named: "kein-bild-symbol.jpg")!)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            TextField("Suche...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)

            Button(action: {
                // Aktion für Benachrichtigungen
            }) {
                Image(systemName: "bell")
                    .font(.title2)
            }
        }
        .padding()
    }


    private func ladeProfilbild() {
        // Hier später Profilbild aus Firestore laden
    }

    
}


#Preview {
    UserHomeView()
        .environmentObject(UserAuthViewModel())
        .environmentObject(TierheimAuthViewModel())
}
