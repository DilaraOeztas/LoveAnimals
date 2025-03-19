//
//  AuthViewModel.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
final class UserAuthViewModel: ObservableObject {
    
    private var auth = Auth.auth()
    @Published var user: FirebaseAuth.User?
    @Published var fireUser: FireUser?
    @Published var errorMessage: String?
    
    @Published var selectedProfession = ""
    @Published var selectedHousing = ""
    @Published var selectedFamily = ""
    @Published var hasGarden = false
    @Published var hasChildren = false
    @Published var numberOfChildren = ""
    @Published var childrenAges = ""
    @Published var hasPets: Bool = false
    @Published var petTypes: String = ""
    @Published var numberOfPets: String = ""
    @Published var petAges: String = ""
    @Published var navigateToHome: Bool = false
    @Published var isTierheim: Bool = false
    
    @Published var profileImage: UIImage? = nil
    @Published var profileImageUrl: String = ""
    

    let userPLZ = "50825"
    
    
    var userID: String? {
        user?.uid
    }
    
    var email: String? {
        user?.email
    }
    
    init() {
        checkAuth()
    }
    
    
    private func checkAuth() {
        guard let currentUser = auth.currentUser else {
            fireUser = FireUser(id: "", firstName: "", lastName: "", email: "", postalCode: "", city: "", birthdate: Date(), signedUpOn: Date(), userType: .user)
            return
        }
        user = auth.currentUser
        ladeUserDaten(userID: currentUser.uid)
    }
    
    
    func register(firstName: String, lastName: String, email: String, password: String, postalCode: String, city: String, birthdate: Date, signedUpOn: Date) async {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            user = result.user
            errorMessage = nil
            guard let email = result.user.email else {
                fatalError("Found a user without an email.") }
            await createUser(
                userID: userID!,
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                postalCode: postalCode,
                city: city,
                birthdate: birthdate,
                signedUpOn: Date(),
                userType: .user
            )
            
            NotificationManager.shared.scheduleDailyNotification()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func createUser(userID: String, firstName: String, lastName: String, email: String, password: String, postalCode: String, city: String, birthdate: Date, signedUpOn: Date, userType: UserType) async {
        let user = FireUser(
            id: userID,
            firstName: firstName,
            lastName: lastName,
            email: email,
            postalCode: postalCode,
            city: city,
            birthdate: birthdate,
            signedUpOn: Date(),
            userType: .user
        )
        do {
            try AuthManager.shared.database.collection("users").document(userID).setData(from: user)
            
            UserDefaults.standard.set(userType.rawValue, forKey: "userType")
            await fetchUser(userID: userID)
            
            DispatchQueue.main.async {
                NotificationManager.shared.requestPermission()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchUser(userID: String) async {
        Task {
            do {
                let snapshot = try await AuthManager.shared.database
                    .collection("users")
                    .document(userID)
                    .getDocument()
                self.fireUser = try snapshot.data(as: FireUser.self)
                
                if let userType = fireUser?.userType {
                    UserDefaults.standard.set(userType.rawValue, forKey: "userType")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func login(email: String, password: String) async {
        if email.isEmpty && password.isEmpty {
            errorMessage = "Please enter your email adress and password."
            return
        } else if email.isEmpty {
            errorMessage = "Please enter your email adress."
            return
        } else if password.isEmpty {
            errorMessage = "Please enter your password."
            return
        }
        
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            user = result.user
            errorMessage = nil

            AuthManager.shared.saveLoginData(email: email, password: password)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set("user", forKey: "loggedInUsertype")
            await fetchUser(userID: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
            user = nil
            errorMessage = nil
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "loggedInUsertype")
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func saveUserDetails(isSkipped: Bool = false) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Fehler: Kein eingeloggter User gefunden.")
            return
        }
        
        if isSkipped {
            do {
                try await AuthManager.shared.database.collection("users")
                    .document(userID)
                    .setData(["profileCompleted": false], merge: true)
            } catch {
                print("Fehler beim Speichern: \(error.localizedDescription)")
            }
            return
        }
        
        var userDetails: [String: Any] = [
            "profession": (selectedProfession == "Beruf auswählen" || selectedProfession.isEmpty) ? "Keine Angabe" : selectedProfession,
            "housingSituation": (selectedHousing == "Wohnsituation auswählen" || selectedHousing.isEmpty) ? "Keine Angabe" : selectedHousing,
            "familyStatus": (selectedFamily == "Familienstand auswählen" || selectedFamily.isEmpty) ? "Keine Angabe" : selectedFamily,
            "hasGarden": hasGarden,
            "hasChildren": hasChildren,
            "hasPets": hasPets,
            "updatedAt": Timestamp(),
        ]
        
        if hasChildren {
            userDetails["numberOfChildren"] = numberOfChildren.isEmpty ? "Keine Angabe" : numberOfChildren
            userDetails["childrenAges"] = childrenAges.isEmpty ? ["Keine Angabe"] : childrenAges
        }
        
        if hasPets {
            userDetails["numberOfPets"] = numberOfPets.isEmpty ? "Keine Angabe" : numberOfPets
            userDetails["petTypes"] = petTypes.isEmpty ? "Keine Angabe" : petTypes
            userDetails["petAges"] = petAges.isEmpty ? "Keine Angabe" : petAges
        }
        
        do {
            try await AuthManager.shared.database.collection("users").document(userID).setData(userDetails, merge: true)
            DispatchQueue.main.async {
                self.navigateToHome = true
            }
        } catch {
            print("Fehler beim Speichern der Daten: \(error.localizedDescription)")
        }
    }
    
    
    func ladeUserDaten(userID: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let data = snapshot?.data(), error == nil {
                DispatchQueue.main.async {
                    self.fireUser = FireUser(
                        id: data["id"] as? String ?? "",
                        firstName: data["firstName"] as? String ?? "Unbekannt",
                        lastName: data["lastName"] as? String ?? "Unbekannt",
                        email: data["email"] as? String ?? "Unbekannt",
                        postalCode: data["postalCode"] as? String ?? "00000",
                        city: data["city"] as? String ?? "Unbekannt",
                        birthdate: data["birthdate"] as? Date ?? Date(),
                        signedUpOn: (data["signedUpOn"] as? Timestamp)?.dateValue() ?? Date(),
                        userType: UserType(rawValue: data["userType"] as? String ?? "") ?? .user
                    )
                }
            } else {
                print("Fehler beim Laden der User-Daten: \(error?.localizedDescription ?? "Unbekannt")")
            }
        }
    }
    
    func loadProfileImage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Fehler beim Laden des Profilbildes: \(error.localizedDescription)")
                return
            }
            if let data = snapshot?.data(), let profileImageUrl = data["profileImageUrl"] as? String {
                DispatchQueue.main.async {
                    self.profileImageUrl = profileImageUrl
                }
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
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Kein eingeloggt Tierheim gefunden")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData([
            "profileImageUrl": imageUrl
        ]) { error in
            if let error = error {
                print("Fehler beim Speichern des Profilbildes: \(error.localizedDescription)")
            } else {
                print("Profilbild erfolgreich gespeichert")
                self.profileImageUrl = imageUrl
            }
        }
        checkAuth()
    }
    
    func deleteProfileImage() {
        guard let tierheimID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(tierheimID).updateData([
            "profileImageUrl": FieldValue.delete()
        ]) { error in
            if let error = error {
                print("Fehler beim Löschen des Profilbildes: \(error.localizedDescription)")
            } else {
                print("Profilbild erfolgreich gelöscht")
                self.profileImageUrl = ""
                self.loadProfileImage()
            }
        }
    }
    
    
    func updateUserDaten(firstName: String, lastName: String, email: String, postalCode: String, city: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Kein User eingeloggt.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        
        userRef.updateData([
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "postalCode": postalCode,
            "city": city
        ]) { error in
            if let error = error {
                print("Fehler beim Aktualisieren der User-Daten: \(error.localizedDescription)")
            } else {
                print("User-Daten erfolgreich aktualisiert.")
                
                self.fireUser?.firstName = firstName
                self.fireUser?.lastName = lastName
                self.fireUser?.email = email
                self.fireUser?.postalCode = postalCode
                self.fireUser?.city = city
            }
        }
    }
}

