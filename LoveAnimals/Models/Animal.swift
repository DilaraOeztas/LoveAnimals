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
    var tierName: String
    var tierart: String
    var rasse: String
    var alter: String
    var groesse: String
    var geschlecht: String
    var farbe: String
    var gesundheitszustand: String
    var beschreibung: String
    var schutzgebuehr: String
    var imageURLs: [String]
    var erstelltAm: Date
    var tierheimID: String
}
