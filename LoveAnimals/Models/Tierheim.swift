//
//  Tierheim.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 19.02.25.
//

import Foundation
import FirebaseFirestore

struct Tierheim: Codable, Identifiable {
    var id: String
    var tierheimName: String
    var adresse: String
    var telefonnummer: String
    var email: String
    var homepage: String

    var akzeptiertBarzahlung: Bool
    var akzeptiertÜberweisung: Bool
    var iban: String?
    var bic: String?

    var nimmtSpendenAn: Bool
    var spendenIban: String?
    var spendenBic: String?

    var verfügbareTage: [String: Bool]
    
    var öffnungszeiten: [String: Öffnungszeit]

    var passwort: String
}

struct Öffnungszeit: Codable {
    var von: Date
    var bis: Date
}
