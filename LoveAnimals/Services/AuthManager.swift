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
    
    func saveLoginData(email: String, password: String) {
        let rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
        if rememberMe {
            UserDefaults.standard.set(email, forKey: "savedEmail")
            UserDefaults.standard.set(password, forKey: "savedPassword")
        } else {
            UserDefaults.standard.removeObject(forKey: "savedEmail")
            UserDefaults.standard.removeObject(forKey: "savedPassword")
        }
    }
    
    func loadLoginData() -> (email: String, password: String, rememberMe: Bool) {
        let email = UserDefaults.standard.string(forKey: "savedEmail") ?? ""
        let password = UserDefaults.standard.string(forKey: "savedPassword") ?? ""
        let rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
        return (email, password, rememberMe)
    }
    
    func setRememberMe(_ remember: Bool) {
        UserDefaults.standard.set(remember, forKey: "rememberMe")
    }
    
    
    func checkIfEmailExistsInFirestore(email: String) async -> Bool {
        let db = Firestore.firestore()
        let query = db.collection("users").whereField("email", isEqualTo: email)
        
        do {
            let snapshot = try await query.getDocuments()
            return !snapshot.documents.isEmpty
        } catch {
            print("❌ Fehler beim E-Mail-Check: \(error.localizedDescription)")
            return false
        }
    }
}

