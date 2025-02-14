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
final class AuthViewModel: ObservableObject {
    
    private var auth = Auth.auth()
    @Published var user: FirebaseAuth.User?
    @Published var fireUser: FireUser?
    @Published var errorMessage: String?
    
    @Published var selectedProfession = "Beruf auswählen"
    @Published var selectedHousing = "Wohnsituation auswählen"
    @Published var hasGarden = false
    @Published var selectedFamily = "Familienstand auswählen"
    @Published var hasChildren = false
    @Published var numberOfChildren = ""
    @Published var childrenAges = ""
    @Published var navigateToHome: Bool = false
    
    var isUserSignedIn: Bool {
        user != nil
    }
    
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
        user = auth.currentUser
    }
    
    
    func register(firstName: String, lastName: String, email: String, password: String, birthdate: Date, signedUpOn: Date) async {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            user = result.user
            errorMessage = nil
            guard let email = result.user.email else {
                fatalError("Found a user without an email.") }
            createUser(
                userID: userID!,
                firstName: firstName,
                lastName: lastName,
                email: email,
                birthdate: birthdate,
                signedUpOn: Date()
            )
            self.navigateToHome = true
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func createUser(userID: String, firstName: String, lastName: String, email: String, birthdate: Date, signedUpOn: Date) {
        let user = FireUser(
            id: userID,
            firstName: firstName,
            lastName: lastName,
            email: email,
            birthdate: birthdate,
            signedUpOn: Date()
        )
        do {
            try AuthManager.shared.database.collection("users").document(userID).setData(from: user)
            fetchUser(userID: userID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchUser(userID: String) {
        Task {
            do {
                let snapshot = try await AuthManager.shared.database
                    .collection("users")
                    .document(userID)
                    .getDocument()
                self.fireUser = try snapshot.data(as: FireUser.self)
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
            saveLoginData(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
            user = nil
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
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
    
    func saveUserDetails() async {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Fehler: Kein eingeloggter User gefunden.")
            return
        }
        
        var userDetails: [String: Any] = [
            "userID": userID,
            "profession": selectedProfession,
            "housingSituation": selectedHousing,
            "hasGarden": hasGarden,
            "familyStatus": selectedFamily,
            "hasChildren": hasChildren,
            "updatedAt": Timestamp()
        ]
        
        if hasChildren {
            userDetails["numberOfChildren"] = numberOfChildren
            userDetails["childrenAges"] = childrenAges
        }
        
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(userID).setData(userDetails, merge: true)
            print("Daten erfolgreich gespeichert!")
            self.navigateToHome = true
        } catch {
            print("Fehler beim Speichern der Daten: \(error.localizedDescription)")
        }
    }
}
