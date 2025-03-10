//
//  Gesundheitszustand.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct Gesundheitszustand: View {
    @Binding var ausgewaehlteGesundheit: String
    @Binding var showGesundheitSheet: Bool
    
    let gesundheit = ["Gesund", "Erkrankt"]
    
    var body: some View {
        NavigationStack {
            List(gesundheit, id: \.self) { gesundheit in
                HStack {
                    Text(gesundheit)
                        .foregroundStyle(.black)
                    Spacer()
                    if gesundheit == ausgewaehlteGesundheit {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewaehlteGesundheit = gesundheit
                    showGesundheitSheet = false
                }
            }
            .navigationTitle("Gesundheitszustand wählen")
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
    Gesundheitszustand(ausgewaehlteGesundheit: .constant(""), showGesundheitSheet: .constant(true))
}
