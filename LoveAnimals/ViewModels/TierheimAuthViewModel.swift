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
    @Published var navigateToHome = false
    
    var isUserSignedIn: Bool {
        userT != nil
    }

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
            self.navigateToHome = true
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
            userType: userType
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
            saveLoginData(email: email, passwort: passwort)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set("tierheim", forKey: "loggedInUsertype")
            navigateToHome = true
            
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        do {
            try auth.signOut()
            userT = nil
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func saveLoginData(email: String, passwort: String) {
        let rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
        if rememberMe {
            UserDefaults.standard.set(email, forKey: "savedEmail")
            UserDefaults.standard.set(passwort, forKey: "savedPassword")
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
    
    func checkIfEmailExistsInFirestore(email: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("tierheime").whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                print("Fehler beim Abrufen: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(!(snapshot?.documents.isEmpty ?? true))
        }
    }
    
  
}
