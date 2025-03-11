//
//  Tierart.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//


enum Tierart: String {
    case hund = "Hund"
    case katze = "Katze"
    case vogel = "Vogel"
    case kaninchen = "Kaninchen"
    
    func rassen() -> [String] {
        switch self {
        case .hund:
            return ["Mischling", "Schäferhund", "Labrador"]
        case .katze:
            return ["Europäisch Kurzhaar", "Maine Coon", "Perser"]
        case .vogel:
            return ["Wellensittich", "Papagei", "Kanarienvogel"]
        case .kaninchen:
            return ["Zwergkaninchen", "Löwenkopfkaninchen", "Rex"]
        }
    }
}
