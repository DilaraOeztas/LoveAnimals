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
    @Published var profileImage: UIImage? = nil
    @Published var profileImageUrl: String?
    
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
        guard let currentUser = auth.currentUser else {
            tierheim = TierheimUser(id: "", tierheimName: "", straße: "", plz: "", ort: "", telefon: "", email: "", homepage: "", nimmtSpendenAn: false, signedUpOn: Date(), userType: .tierheim)
            return
        }
        userT = auth.currentUser
        ladeTierheimDaten(tierheimID: currentUser.uid)
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
                    self.loadProfileImage()
                }
            } else {
                print("Fehler beim Laden der Tierheim-Daten: \(error?.localizedDescription ?? "Unbekannt")")
            }
        }
    }
    
    func loadProfileImage() {
        guard let tierheimID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("tierheime").document(tierheimID).getDocument { snapshot, error in
            if let error = error {
                print("Fehler beim Laden des Profilbildes: \(error.localizedDescription)")
                return
            }
            if let data = snapshot?.data(), let profileImageUrl = data["profileImageUrl"] as? String {
                self.profileImageUrl = profileImageUrl
            }
        }
    }
    
    func uploadProfileImage() {
        guard let profileImage = profileImage else {
            print("Kein Bild zum Hochladen")
            return
        }
        self.objectWillChange.send()
        Task {
            do {
                let imageUrl = try await ImgurService.uploadImage(profileImage)
                saveProfileImageURLToFirestore(imageUrl)
                loadProfileImage()
            } catch {
                print("Fehler beim Hochladen des Profilbilds: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func saveProfileImageURLToFirestore(_ imageUrl: String) {
        guard let tierheimID = Auth.auth().currentUser?.uid else {
            print("Kein eingeloggt Tierheim gefunden")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("tierheime").document(tierheimID).updateData([
            "profileImageUrl": imageUrl
        ]) { error in
            if let error = error {
                print("Fehler beim Speichern des Profilbildes: \(error.localizedDescription)")
            } else {
                print("Profilbild erfolgreich gespeichert")
            }
        }
    }
    
    func deleteProfileImage() {
        guard let tierheimID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("tierheime").document(tierheimID).updateData([
            "profileImageUrl": FieldValue.delete()
        ]) { error in
            if let error = error {
                print("Fehler beim Löschen des Profilbildes: \(error.localizedDescription)")
            } else {
                print("Profilbild erfolgreich gelöscht")
                self.profileImageUrl = nil
            }
        }
    }
    
    func updateTierheimDaten(tierheimName: String, email: String, homepage: String, telefon: String, straße: String, plz: String, ort: String) {
        guard let tierheimID = Auth.auth().currentUser?.uid else {
            print("Kein Tierheim-User eingeloggt.")
            return
        }
        
        let db = Firestore.firestore()
        let tierheimRef = db.collection("tierheime").document(tierheimID)
        
        tierheimRef.updateData([
            "tierheimName": tierheimName,
            "email": email,
            "homepage": homepage,
            "telefon": telefon,
            "straße": straße,
            "plz": plz,
            "ort": ort
        ]) { error in
            if let error = error {
                print("Fehler beim Aktualisieren der Tierheim-Daten: \(error.localizedDescription)")
            } else {
                print("Tierheim-Daten erfolgreich aktualisiert.")
                
                self.tierheim?.tierheimName = tierheimName
                self.tierheim?.email = email
                self.tierheim?.homepage = homepage
                self.tierheim?.telefon = telefon
                self.tierheim?.straße = straße
                self.tierheim?.plz = plz
                self.tierheim?.ort = ort
            }
        }
    }
}



