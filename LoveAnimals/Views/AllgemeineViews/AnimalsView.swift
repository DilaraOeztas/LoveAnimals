//
//  AnimalsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

import SwiftUI
import FirebaseFirestore

struct AnimalsView: View {
    let animal: Animal
    let userCoordinates: (latitude: Double, longitude: Double)?

    @State private var tierheimPLZ = ""

    var body: some View {
        VStack(alignment: .center) {
            if let firstImageURL = animal.bilder.first, let url = URL(string: firstImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 90)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 70)
                            .clipShape(Circle())
                    case .failure:
                        Image("hund")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 70)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("hund")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 70)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(animal.name)
                    .font(.headline)
                
                if let userCoordinates {
                    if !tierheimPLZ.isEmpty {
                        let distance = DistanceCalculator.calculateDistance(
                            from: userCoordinates,
                            toPLZ: tierheimPLZ
                        )
                        Text(String(format: "%.1f km entfernt", distance))
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .onAppear {
            ladeTierheimPLZ()
        }
    }

    
    
    func ladeTierheimPLZ() {
        let db = Firestore.firestore()
        db.collection("tierheime").document(animal.tierheimID).getDocument { snapshot, error in
            if let data = snapshot?.data(), let plz = data["plz"] as? String {
                tierheimPLZ = plz
            } else {
                print("Fehler beim Laden der PLZ: \(error?.localizedDescription ?? "Unbekannt")")
            }
        }
    }
}


#Preview {
    AnimalsView(animal: Animal(name: "Test", tierart: "Hund", rasse: "Mischling", alter: "2 Jahre", groesse: "Mittel", geschlecht: "weiblich", farbe: "schwarz", gesundheit: "gesund", beschreibung: "Sehr verspielt", schutzgebuehr: "250", bilder: ["https//placekitten.com/400/300"], erstelltAm: Date(), tierheimID: "12345"), userCoordinates: (latitude: 50.1109, longitude: 8.6821))
}





















//struct AnimalsView: View {
//    let animal: Animal
//    let userCoordinates: (latitude: Double, longitude: Double)?
//
//    @State private var tierheimName = ""
//    @State private var tierheimPLZ = ""
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            if let firstImageURL = animal.imageURLs.first, let url = URL(string: firstImageURL) {
//                AsyncImage(url: url) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .frame(width: 100, height: 90)
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 90)
//                            .clipShape(Circle())
//                    case .failure:
//                        Image("Dilara")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 90)
//                            .foregroundColor(.gray)
//                            .clipShape(Circle())
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//            } else {
//                Image("hund")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 90)
//                    .clipShape(Circle())
//                    .foregroundColor(.gray)
//            }
//
//            VStack(alignment: .leading, spacing: -4) {
//                Text(animal.tierName).font(.headline)
//                Text(tierheimName).font(.subheadline)
//
//
//                if let userCoordinates {
//                    let distance = DistanceCalculator.calculateDistance(
//                        from: userCoordinates,
//                        toPLZ: tierheimPLZ
//                    )
//                    Text(String(format: "%.1f km entfernt", distance))
//                        .font(.footnote)
//                        .foregroundColor(.gray)
//                }
//            }
//        }
//        .onAppear {
//            ladeTierheimDaten()
//        }
//    }
//
//    func ladeTierheimDaten() {
//        let db = Firestore.firestore()
//        db.collection("tierheime").document(animal.tierheimID).getDocument { snapshot, error in
//            if let data = snapshot?.data() {
//                tierheimName = data["tierheimName"] as? String ?? "Unbekanntes Tierheim"
//                tierheimPLZ = data["plz"] as? String ?? "00000"
//            } else {
//                print("Fehler beim Laden der Tierheimdaten: \(error?.localizedDescription ?? "Unbekannt")")
//            }
//        }
//    }
//}


