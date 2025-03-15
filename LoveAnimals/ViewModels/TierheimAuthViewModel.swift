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
    @Published var tierheim: TierheimUser?
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
    
    func registerTierheim(tierheimName: String, straße: String, plz: String, ort: String, telefon: String, email: String, homepage: String? = nil, nimmtSpendenAn: Bool, passwort: String, signedUpOn: Date) async {
        
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
                telefon: telefon,
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
    
    func createUserT(userId: String, tierheimName: String, straße: String, plz: String, ort: String, telefon: String, email: String, homepage: String? = nil, nimmtSpendenAn: Bool, passwort: String, signedUpOn: Date, userType: UserType) async {
        
        let userT = TierheimUser(
            id: userId,
            tierheimName: tierheimName,
            straße: straße,
            plz: plz,
            ort: ort,
            telefon: telefon,
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
                self.tierheim = try snapshot.data(as: TierheimUser.self)
                
                if let userType = tierheim?.userType {
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
    
   

        func ladeTierheimDaten(tierheimID: String) {
            let db = Firestore.firestore()
            
            db.collection("tierheime").document(tierheimID).getDocument { snapshot, error in
                if let data = snapshot?.data(), error == nil {
                    DispatchQueue.main.async {
                        self.tierheim = TierheimUser(
                            id: data["id"] as? String ?? "",
                            tierheimName: data["tierheimName"] as? String ?? "Unbekannt",
                            straße: data["straße"] as? String ?? "Unbekannt",
                            plz: data["plz"] as? String ?? "00000",
                            ort: data["ort"] as? String ?? "Unbekannt",
                            telefon: data["telefon"] as? String ?? "Unbekannt",
                            email: data["email"] as? String ?? "Unbekannt",
                            homepage: data["homepage"] as? String ?? "Nicht angegeben",
                            nimmtSpendenAn: data["nimmtSpendenAn"] as? Bool ?? false,
                            signedUpOn: (data["signedUpOn"] as? Timestamp)?.dateValue() ?? Date(),
                            userType: UserType(rawValue: data["userType"] as? String ?? "") ?? .tierheim
                        )
                    }
                } else {
                    print("Fehler beim Laden der Tierheim-Daten: \(error?.localizedDescription ?? "Unbekannt")")
                }
            }
        }
    
}



