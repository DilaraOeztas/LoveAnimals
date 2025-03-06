//
//  TierDaten.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 05.03.25.
//

import Foundation

struct TierDaten: Codable {
    var name: String
    var art: String
    var rasse: String
    var alter: String
    var groesse: String
    var geschlecht: String
    var farbe: String
    var gesundheit: String
    var beschreibung: String
    var schutzgebuehr: String
    var bilderURLs: [String]
}
