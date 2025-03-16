//
//  Chat.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import Foundation

struct Chat: Identifiable {
    let id: Int
    let name: String
    let lastMessage: String
    let timestamp: String
    let isToday: Bool
}

