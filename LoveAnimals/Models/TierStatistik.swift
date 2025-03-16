//
//  TierStatistik.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 14.03.25.
//

import Foundation

struct TierStatistik: Identifiable {
    let id = UUID()
    let name: String
    let aufrufe: Int
    let interessenten: Int
    let favoriten: Int
}

