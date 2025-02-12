//
//  User.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import Foundation
import FirebaseFirestore

struct FireUser: Codable, Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var birthdate: Date
    var signedUpOn: Date
    var hasCompletedProfile: Bool
}
