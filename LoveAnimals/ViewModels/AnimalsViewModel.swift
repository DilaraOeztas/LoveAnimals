//
//  AnimalsViewModel.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


@MainActor
class AnimalsViewModel: ObservableObject {
    @Published var animals: [Animal] = []
    @Published var favoriten: [Animal] = []
    @Published var isLoading: Bool = false
    @Published var showPostUploadToast = false

    
    init() {
        Task {
            await ladeAlleTiere()
        }
    }
    
    func triggerPostUploadToast() {
        showPostUploadToast = true
    }

    func ladeAlleTiere() async {
        
        isLoading = true
        animals.removeAll()
        
        let db = Firestore.firestore()

        do {
            let tierheimeSnapshot = try await db.collection("tierheime").getDocuments()

            for document in tierheimeSnapshot.documents {
                let tierheimID = document.documentID
                let tiereSnapshot = try await db.collection("tierheime")
                    .document(tierheimID)
                    .collection("Tiere")
                    .getDocuments()

                for tierDocument in tiereSnapshot.documents {
                    var animal = try tierDocument.data(as: Animal.self)

                    if let timestamp = tierDocument["geburtsdatum"] as? Timestamp {
                        animal.geburtsdatum = timestamp.dateValue()
                    } else {
                        animal.geburtsdatum = nil
                    }
                    animal.tierheimID = tierheimID
                    animals.append(animal)
                }
            }

            print("Es wurden \(animals.count) Tiere geladen.")
        } catch {
            print("Fehler beim Laden der Tiere: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func addFavorite(animal: Animal) async {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        do {
            try await db.collection("users")
                .document(userID)
                .collection("favoriten")
                .document(animal.id ?? UUID().uuidString)
                .setData(animal.asDictionary())

            print("Favorit hinzugefügt")
            await loadFavorites()
        } catch {
            print("Fehler beim Speichern des Favoriten: \(error.localizedDescription)")
        }
    }

    func removeFavorite(animalID: String) async {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        do {
            try await db.collection("users")
                .document(userID)
                .collection("favoriten")
                .document(animalID)
                .delete()

            print("Favorit entfernt")
            await loadFavorites()
        } catch {
            print("Fehler beim Löschen des Favoriten: \(error.localizedDescription)")
        }
    }

    func loadFavorites() async {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        do {
            let snapshot = try await db.collection("users")
                .document(userID)
                .collection("favoriten")
                .getDocuments()

            let favorites = snapshot.documents.compactMap { try? $0.data(as: Animal.self) }
            DispatchQueue.main.async {
                self.favoriten = favorites
            }
        } catch {
            print("Fehler beim Laden der Favoriten: \(error.localizedDescription)")
        }
    }
}


