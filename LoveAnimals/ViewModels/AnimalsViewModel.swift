//
//  AnimalsViewModel.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class AnimalsViewModel: ObservableObject {
    @Published var animals: [Animal] = []

    func ladeAlleTiere() async {
        let db = Firestore.firestore()
        animals.removeAll()  // Wichtig: Immer erst leeren, sonst doppelte Einträge bei erneutem Laden

        do {
            // 1. Alle Tierheime laden
            let tierheimeSnapshot = try await db.collection("tierheime").getDocuments()

            // 2. Für jedes Tierheim die Tiere laden
            for document in tierheimeSnapshot.documents {
                let tierheimID = document.documentID
                let tiereSnapshot = try await db.collection("tierheime")
                    .document(tierheimID)
                    .collection("tiere")
                    .getDocuments()

                for tierDocument in tiereSnapshot.documents {
                    var animal = try tierDocument.data(as: Animal.self)
                    animal.tierheimID = tierheimID // Die tierheimID aus dem Pfad hinzufügen!
                    animals.append(animal)
                }
            }

            print("Es wurden \(animals.count) Tiere geladen.")
        } catch {
            print("Fehler beim Laden der Tiere: \(error.localizedDescription)")
        }
    }
}
