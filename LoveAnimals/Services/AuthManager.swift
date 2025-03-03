//
//  AuthManager.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

import Foundation
import FirebaseFirestore

@MainActor
class AuthManager: ObservableObject {
    
    static let shared = AuthManager()

    private init() {}

    let database = Firestore.firestore()


    func checkUserType(email: String) async -> UserType? {
        if let userType = await fetchUserTypeByEmail(collection: "users", email: email) {
            return userType
        } else if let userType = await fetchUserTypeByEmail(collection: "tierheime", email: email) {
            return userType
        }
        return nil
    }

 
    private func fetchUserTypeByEmail(collection: String, email: String) async -> UserType? {
        let query = database.collection(collection)
            .whereField("email", isEqualTo: email)

        do {
            let snapshot = try await query.getDocuments()
            if let document = snapshot.documents.first,
               let userTypeString = document.data()["userType"] as? String,
               let userType = UserType(rawValue: userTypeString) {
                return userType
            }
        } catch {
            print("Fehler beim Abrufen von \(collection): \(error.localizedDescription)")
        }
        return nil
    }
    
    
}
