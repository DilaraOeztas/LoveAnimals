//
//  AnimalDetailView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 05.03.25.
//

import SwiftUI

struct AnimalDetailView: View {
    let animal: Animal

    var body: some View {
        ScrollView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(animal.imageURLs, id: \.self) { imageURL in
                            if let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 250, height: 250)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 250, height: 250)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 250, height: 250)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                }

                Text("Name: \(animal.tierName)")
                    .font(.title2)

                Text("Rasse: \(animal.rasse)")
                Text("Alter: \(animal.alter)")
                Text("Geschlecht: \(animal.geschlecht)")
                Text("Größe: \(animal.groesse)")
                Text("Farbe: \(animal.farbe)")
                Text("Gesundheitszustand: \(animal.gesundheitszustand)")

                Text("Beschreibung")
                    .font(.headline)
                    .padding(.top, 8)
                Text(animal.beschreibung)
                    .padding(.bottom, 16)

                Text("Schutzgebühr: \(animal.schutzgebuehr) €")
                    .font(.headline)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(animal.tierName)
    }
}

#Preview {
    AnimalDetailView(animal: Animal(tierName: "Test", tierart: "Hund", rasse: "Mischling", alter: "2 Jahre", groesse: "Mittel", geschlecht: "weiblich", farbe: "schwarz", gesundheitszustand: "gesund", beschreibung: "Sehr verspielt", schutzgebuehr: "250", imageURLs: ["https//placekitten.com/400/300"], erstelltAm: Date(), tierheimID: "12345"))
}
