//
//  AnimalDetailView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 05.03.25.
//

import SwiftUI

struct AnimalDetailView: View {
    @EnvironmentObject var viewModel: AnimalsViewModel
    @State private var isFavorite: Bool = false
    let animal: Animal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(animal.bilder, id: \.self) { bild in
                            if let url = URL(string: bild) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 250, height: 150)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 350, height: 250)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 350, height: 250)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    .padding(.top)
                }
                detailText(title: "Name:", value: animal.name)
                detailText(title: "Rasse:", value: animal.rasse)
                detailText(title: "Alter:", value: animal.alter)
                detailText(title: "Größe:", value: animal.groesse)
                detailText(title: "Farbe:", value: animal.farbe)
                detailText(title: "Geschlecht:", value: animal.geschlecht)
                detailText(title: "Gesundheitszustand:", value: animal.gesundheit)
                detailText(title: "Schutzgebühr:", value: animal.schutzgebuehr + " €")
                detailText(title: "Beschreibung:", value: animal.beschreibung)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Über das Tier")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        if isFavorite {
                            await viewModel.removeFavorite(animalID: animal.id ?? "")
                            isFavorite = false
                        } else {
                            await viewModel.addFavorite(animal: animal)
                            isFavorite = true
                        }
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            isFavorite = viewModel.favoriten.contains(where: { $0.id == animal.id })
        }
    }
    
    
    
    
    
    @ViewBuilder
    private func detailText(title: String, value: String) -> some View {
        if title == "Beschreibung:" {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .bold()
                Text(value)
            }
            .padding(.top, 25)
        } else {
            HStack(alignment: .top) {
                Text(title)
                    .bold()
                Spacer()
                Text(value)
            }
        }
    }
}

#Preview {
    AnimalDetailView(animal: Animal(name: "Test", tierart: "Hund", rasse: "Mischling", alter: "2 Jahre", groesse: "Mittel", geschlecht: "weiblich", farbe: "schwarz", gesundheit: "gesund", beschreibung: "Sehr verspielt", schutzgebuehr: "250", bilder: ["https//placekitten.com/400/300"], erstelltAm: Date(), tierheimID: "12345"))
        .environmentObject(AnimalsViewModel())
}
