//
//  PasswortKriterien.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 17.02.25.
//

import SwiftUI

struct PasswortKriterien: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isValid ? .green : .red)
            Text(text)
                .foregroundStyle(isValid ? .green : .red)
        }
    }
}

#Preview {
    PasswortKriterien(text: "Test", isValid: true)
}
