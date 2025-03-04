//
//  TierartSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct TierartSheet: View {
    @Binding var ausgewählteTierart: String
    @Binding var showTierartSheet: Bool
    
    let tierarten = ["Hund", "Katze", "Vogel", "Kaninchen", "Meerschweinchen", "Reptil", "Fisch", "Sonstiges"]
    
    var body: some View {
        NavigationStack {
            List(tierarten, id: \.self) { tierart in
                HStack {
                    Text(tierart)
                        .foregroundStyle(.black)
                    Spacer()
                    if tierart == self.ausgewählteTierart {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewählteTierart = tierart
                    showTierartSheet = false
                }
            }
            .navigationTitle("Tierart auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showTierartSheet = false
                    }
                }
            }
        }
    }
}


#Preview {
    TierartSheet(ausgewählteTierart: .constant(""), showTierartSheet: .constant(true))
}
