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
    var akzeptiertBarzahlung: Bool
    var akzeptiertÜberweisung: Bool
    var empfaengername: String?
    var iban: String?
    var bic: String?
    var nimmtSpendenAn: Bool
    var spendenIban: String?
    var spendenBic: String?
    var verfügbareTage: [String: Bool]
    var öffnungszeiten: [String: [Oeffnungszeit]]
    var passwort: String
    var signedUpOn: Date
}

struct Oeffnungszeit: Codable {
    var von: Date
    var bis: Date
}
