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
    
    
    func register(firstName: String, lastName: String, email: String, password: String, postalCode: String, city: String, birthdate: Date, searchRadius: Int, signedUpOn: Date) async {
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
                searchRadius: searchRadius,
                signedUpOn: Date(),
                userType: UserType.user
            )
            self.navigateToHome = true
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func createUser(userID: String, firstName: String, lastName: String, email: String, password: String, postalCode: String, city: String, birthdate: Date, searchRadius: Int, signedUpOn: Date, userType: UserType) async {
        let user = FireUser(
            id: userID,
            firstName: firstName,
            lastName: lastName,
            email: email,
            postalCode: postalCode,
            city: city,
            birthdate: birthdate,
            searchRadius: searchRadius,
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
    
    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "LoveAnimals Erinnerung"
        content.body = "Vergiss nicht, neue Tiere zu entdecken!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Fehler beim Planen der täglichen Benachrichtigung: \(error.localizedDescription)")
            } else {
                print("Tägliche Benachrichtigung geplant ✅")
            }
        }
    }

    
}

