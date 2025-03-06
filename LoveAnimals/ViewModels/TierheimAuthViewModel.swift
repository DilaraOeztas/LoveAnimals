//
//  TierheimAuthViewModel.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 19.02.25.
//

import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class TierheimAuthViewModel: ObservableObject {
    private var auth = Auth.auth()
    @Published var userT: FirebaseAuth.User?
    @Published var tierheimUser: TierheimUser?
    @Published var errorMessage: String?
    @Published var animals: [Animal] = []
    @Published var aktuelleTierID: String = UUID().uuidString
    
    var userId: String? {
        userT?.uid
    }
    
    var email: String? {
        userT?.email
    }
    
    init() {
        checkAuth()
    }
    
    private func checkAuth() {
        userT = auth.currentUser
    }
    
    func registerTierheim(tierheimName: String, straße: String, plz: String, ort: String, email: String, homepage: String? = nil, nimmtSpendenAn: Bool, passwort: String, signedUpOn: Date) async {
        
        do {
            let result = try await auth.createUser(withEmail: email, password: passwort)
            userT = result.user
            errorMessage = nil
            
            guard let email = result.user.email else {
                fatalError("Found a User without an email.") }
            
            await createUserT(
                userId: userId!,
                tierheimName: tierheimName,
                straße: straße,
                plz: plz,
                ort: ort,
                email: email,
                homepage: homepage,
                nimmtSpendenAn: false,
                passwort: passwort,
                signedUpOn: Date(),
                userType: .tierheim
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func createUserT(userId: String, tierheimName: String, straße: String, plz: String, ort: String, email: String, homepage: String? = nil, nimmtSpendenAn: Bool, passwort: String, signedUpOn: Date, userType: UserType) async {
        
        let userT = TierheimUser(
            id: userId,
            tierheimName: tierheimName,
            straße: straße,
            plz: plz,
            ort: ort,
            email: email,
            homepage: homepage,
            nimmtSpendenAn: false,
            signedUpOn: Date(),
            userType: .tierheim
        )
        do {
            try AuthManager.shared.database.collection("tierheime").document(userId).setData(from: userT)
            
            UserDefaults.standard.set(userType.rawValue, forKey: "userType")
            await fetchTierheim(userId: userId)
            
            DispatchQueue.main.async {
                NotificationManager.shared.requestPermission()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchTierheim(userId: String) async {
        Task {
            do {
                let snapshot = try await AuthManager.shared.database
                    .collection("tierheime")
                    .document(userId)
                    .getDocument()
                self.tierheimUser = try snapshot.data(as: TierheimUser.self)
                
                if let userType = tierheimUser?.userType {
                    UserDefaults.standard.set(userType.rawValue, forKey: "userType")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func login(email: String, passwort: String) async {
        if email.isEmpty && passwort.isEmpty {
            errorMessage = "Please enter your email adress and password."
            return
        } else if email.isEmpty {
            errorMessage = "Please enter your email adress."
            return
        } else if passwort.isEmpty {
            errorMessage = "Please enter your password."
            return
        }
        
        do {
            let result = try await auth.signIn(withEmail: email, password: passwort)
            userT = result.user
            errorMessage = nil
            AuthManager.shared.saveLoginData(email: email, password: passwort)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set("tierheim", forKey: "loggedInUsertype")
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
            userT = nil
            errorMessage = nil
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "loggedInUsertype")
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    
    
//    func ladeTiereAusTierheim() async {
//        let db = Firestore.firestore()
//        
//        do {
//            let snapshot = try await db.collection("tiere").getDocuments()
//            
//            let geladeneTiere = snapshot.documents.compactMap { doc -> Animal? in
//                let data = doc.data()
//                
//                guard let tierName = data["tierName"] as? String,
//                      let tierart = data["tierart"] as? String,
//                      let rasse = data["rasse"] as? String,
//                      let alter = data["alter"] as? String,
//                      let groesse = data["groesse"] as? String,
//                      let geschlecht = data["geschlecht"] as? String,
//                      let farbe = data["farbe"] as? String,
//                      let gesundheitszustand = data["gesundheitszustand"] as? String,
//                      let beschreibung = data["beschreibung"] as? String,
//                      let schutzgebuehr = data["schutzgebuehr"] as? String,
//                      let imageURLs = data["imageURLs"] as? [String],
//                      let erstelltAm = (data["erstelltAm"] as? Timestamp)?.dateValue(),
//                      let tierheimID = data["tierheimID"] as? String else {
//                    print("⚠️ Ein Tier-Dokument hat fehlerhafte Daten und wird übersprungen.")
//                    return nil
//                }
//                
//                // Rückgabe des vollständig erstellten `Animal`-Objekts
//                return Animal(
//                    tierName: tierName,
//                    tierart: tierart,
//                    rasse: rasse,
//                    alter: alter,
//                    groesse: groesse,
//                    geschlecht: geschlecht,
//                    farbe: farbe,
//                    gesundheitszustand: gesundheitszustand,
//                    beschreibung: beschreibung,
//                    schutzgebuehr: schutzgebuehr,
//                    imageURLs: imageURLs,
//                    erstelltAm: erstelltAm,
//                    tierheimID: tierheimID
//                )
//            }
//            
//            DispatchQueue.main.async {
//                self.animals = geladeneTiere
//            }
//            
//        } catch {
//            print("❌ Fehler beim Abrufen der Tiere: \(error.localizedDescription)")
//        }
//    }
}



