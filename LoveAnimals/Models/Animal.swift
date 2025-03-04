//
//  Animal.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

import Foundation

struct Animal: Identifiable {
    let id = UUID()
    let name: String
    let imageURL: String
    let tierheimName: String
    let tierheimPLZ: String
}
