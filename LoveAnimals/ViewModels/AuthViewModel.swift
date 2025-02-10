//
//  AuthViewModel.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String? = nil
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.user = result?.user
            completion(true)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.user = result?.user
            completion(true)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
