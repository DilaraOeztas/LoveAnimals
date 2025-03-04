//
//  Gesundheitszustand.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct Gesundheitszustand: View {
    @Binding var ausgewählteGesundheit: String
    @Binding var showGesundheitSheet: Bool
    
    let gesundheit = ["Gesund", "Erkrankt"]
    
    var body: some View {
        NavigationStack {
            List(gesundheit, id: \.self) { gesundheit in
                HStack {
                    Text(gesundheit)
                        .foregroundStyle(.black)
                    Spacer()
                    if gesundheit == self.ausgewählteGesundheit {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewählteGesundheit = gesundheit
                    showGesundheitSheet = false
                }
            }
            .navigationTitle("Geschlecht auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showGesundheitSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    Gesundheitszustand(ausgewählteGesundheit: .constant(""), showGesundheitSheet: .constant(true))
}
