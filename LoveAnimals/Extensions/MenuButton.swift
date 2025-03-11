//
//  MenuButton.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 11.03.25.
//

import SwiftUI


struct MenuButton: View {
    var title: String
    var systemImage: String
    var isDestructive: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundStyle(isDestructive ? .red : .primary)
                Text(title)
                    .foregroundStyle(isDestructive ? .red : .primary)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
}
