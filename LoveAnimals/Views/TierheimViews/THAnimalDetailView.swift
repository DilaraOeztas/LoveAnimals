//
//  THAnimalDetailView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 14.03.25.
//

import SwiftUI

struct THAnimalDetailView: View {
    @EnvironmentObject var viewModel: AnimalsViewModel
    @EnvironmentObject var thAuthVM: TierheimAuthViewModel
    @State private var isFavorite: Bool = false
    @State private var navigateBack = false
    
    @Binding var selectedTab: Int
    @State var animal: Animal
    @State private var selectedImageIndex: Int?
    
    let altersangaben: [String: String] = [
        "Jung": "< 1 Jahr",
        "Erwachsen": "1 - 6 Jahre",
        "Senior": "> 6 Jahre"
    ]
    
    let groessenAngaben: [String: String] = [
        "Klein": "< 30 cm",
        "Mittel": "30 - 60 cm",
        "Groß": "> 60 cm"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        if animal.bilder.isEmpty {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 350, height: 250)
                                .overlay(
                                    Text("Keine Bilder vorhanden")
                                        .foregroundStyle(.black)
                                        .bold()
                                )
                                .cornerRadius(10)
                        } else {
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
                                                .onTapGesture {
                                                    if let index = animal.bilder.firstIndex(of: bild) {
                                                        selectedImageIndex = index
                                                    }
                                                }
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
                    }
                    .padding(.bottom, 30)
                    .padding(.top)
                }
                detailText(title: "Name:", value: animal.name)
                Divider()
                detailText(title: "Tierart:", value: animal.tierart)
                Divider()
                detailText(title: "Rasse:", value: animal.rasse)
                Divider()
                
                HStack {
                    Text("Alter:")
                        .bold()
                    Spacer()
                    if let altersangabe = altersangaben[animal.alter] {
                        Text(altersangabe)
                    }
                    Text("| \(animal.alter)")
                }
                Divider()
                HStack {
                    Text("Geburtsdatum:")
                        .bold()
                    Spacer()
                    if let geburtsdatum = animal.geburtsdatum, geburtsdatum != Date() {
                        Text(geburtsdatum.formatted(date: .long, time: .omitted))
                    } else {
                        Text("Nicht bekannt")
                            .foregroundStyle(.gray)
                    }
                }
                Divider()
                HStack {
                    Text("Größe")
                        .bold()
                    Spacer()
                    
                    if let groessenAngabe = groessenAngaben[animal.groesse] {
                        Text(groessenAngabe)
                    }
                    Text("| \(animal.groesse)")
                }
                Divider()
                detailText(title: "Farbe:", value: animal.farbe)
                Divider()
                detailText(title: "Geschlecht:", value: animal.geschlecht)
                Divider()
                detailText(title: "Gesundheitszustand:", value: animal.gesundheit)
                Divider()
                detailText(title: "Schutzgebühr:", value: animal.schutzgebuehr + " €")
                Divider()
                detailText(title: "Beschreibung:", value: animal.beschreibung)
                
                
                if let tierheim = thAuthVM.tierheim {
                    Divider()
                    Text("Informationen zum Tierheim")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    detailText(title: "Name:", value: tierheim.tierheimName)
                    detailText(title: "Homepage:", value: tierheim.homepage ?? "Nicht angegeben")
                    detailText(title: "Telefon:", value: tierheim.telefon)
                    detailText(title: "Adresse:", value: tierheim.straße)
                    detailText(title: "Ort:", value: "\(tierheim.plz), \(tierheim.ort)")
                    detailText(title: "E-Mail:", value: tierheim.email)
                }
                
                Button(action: {
                   
                }) {
                    Text("Tierheim kontaktieren")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.customLightBrown)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Über das Tier")
        .onAppear {
            thAuthVM.ladeTierheimDaten(tierheimID: animal.tierheimID)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if animal.tierheimID == thAuthVM.userId {
                    NavigationLink(destination: TierEinstellenView(navigateBack: $navigateBack, selectedTab: $selectedTab, animal: animal)) {
                        Text("Bearbeiten")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: Binding<Bool>(
            get: { selectedImageIndex != nil },
            set: { if !$0 { selectedImageIndex = nil } }
        )) {
            if let index = selectedImageIndex {
                ImageFullScreenView(images: animal.bilder, selectedIndex: index) {
                    selectedImageIndex = nil
                }
            }
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
