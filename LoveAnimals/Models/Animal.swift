//
//  Animal.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

import Foundation
import FirebaseFirestore

struct Animal: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var tierart: String
    var rasse: String
    var alter: String
    var geburtsdatum: Date?
    var groesse: String
    var geschlecht: String
    var farbe: String
    var gesundheit: String
    var beschreibung: String
    var schutzgebuehr: String
    var bilder: [String]
    var erstelltAm: Date
    var tierheimID: String
}


extension Animal {
    func asDictionary() -> [String: Any] {
        return [
            "name": name,
            "tierart": tierart,
            "rasse": rasse,
            "alter": alter,
            "geburtsdatum": geburtsdatum != nil ? Timestamp(date: geburtsdatum!) : NSNull(),
            "groesse": groesse,
            "geschlecht": geschlecht,
            "farbe": farbe,
            "gesundheit": gesundheit,
            "beschreibung": beschreibung,
            "schutzgebuehr": schutzgebuehr,
            "bilder": bilder,
            "erstelltAm": Timestamp(date: erstelltAm),
            "tierheimID": tierheimID
        ]
    }
}
