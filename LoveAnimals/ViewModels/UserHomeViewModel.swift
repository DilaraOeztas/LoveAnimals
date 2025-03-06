//
//  UserHomeViewModel.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class UserHomeViewModel: ObservableObject {
    @Published var alleTiere: [Animal] = []
    
    func ladeAlleTiere() async {
        alleTiere.removeAll()
        
        let db = Firestore.firestore()
        do {
            let tierheimSnapshot = try await db.collection("tierheime").getDocuments()
            
            for tierheimDoc in tierheimSnapshot.documents {
                let tierheimID = tierheimDoc.documentID
                let tiereSnapshot = try await db.collection("tierheime").document(tierheimID).collection("Tiere").getDocuments()
                
                for tierDoc in tiereSnapshot.documents {
                    if let tier = try? tierDoc.data(as: Animal.self) {
                        alleTiere.append(tier)
                    }
                }
            }
        } catch {
            print("Fehler beim Laden der Tiere: \(error.localizedDescription)")
        }
    }
}
