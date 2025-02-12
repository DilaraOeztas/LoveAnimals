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
        if let uid = user?.uid {
            fetchUser(userID: uid)
        }
    }
    
    
    func register(firstName: String, lastName: String, email: String, password: String, birthdate: Date, signedUpOn: Date) async {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            user = result.user
            errorMessage = nil
            guard let email = result.user.email else { fatalError("Found a user without an email.") }
            createUser(userID: userID!, firstName: firstName, lastName: lastName, email: email, birthdate: Date(), signedUpOn: Date())
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func login(email: String, password: String) async {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            user = result.user
            errorMessage = nil
            fetchUser(userID: result.user.uid)
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
    
    func createUser(userID: String, firstName: String, lastName: String, email: String, birthdate: Date, signedUpOn: Date) {
        let user = FireUser(id: userID, firstName: firstName, lastName: lastName, email: email, birthdate: Date(), signedUpOn: Date())
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
                let snapshot = try await AuthManager.shared.database.collection("users").document(userID).getDocument()
                self.fireUser = try snapshot.data(as: FireUser.self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
