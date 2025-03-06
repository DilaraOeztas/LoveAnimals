//
//  TierOptionView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct TierOptionView: View {
    let title: String
    let value: String
    var action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white)
            Spacer()
            Text(value)
                .foregroundStyle(Color.customBrown)
            Image(systemName: "chevron.right")
                .foregroundStyle(.white)
        }
        .padding(10)
        .background(Color.customLightBrown)
        .cornerRadius(8)
        .onTapGesture {
            action()
        }
    }
}
