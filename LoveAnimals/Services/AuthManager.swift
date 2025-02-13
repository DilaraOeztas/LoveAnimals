//
//  AuthManager.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import FirebaseAuth
import FirebaseFirestore

final class AuthManager {

    static let shared = AuthManager()
    private init() {}

    let auth = Auth.auth()
    let database = Firestore.firestore()
}
