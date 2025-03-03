//
//  Tierheim.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 19.02.25.
//

import Foundation
import FirebaseFirestore

struct TierheimUser: Codable, Identifiable {
    var id: String
    var tierheimName: String
    var straße: String
    var plz: String
    var ort: String
    var email: String
    var homepage: String?
    var nimmtSpendenAn: Bool
    var signedUpOn: Date
    var userType: UserType
}

