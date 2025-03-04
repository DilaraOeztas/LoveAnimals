//
//  GroessenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct GroessenSheet: View {
    @Binding var ausgewählteGröße: String
    @Binding var showGroessenSheet: Bool
    
    let größen = ["Klein", "Mittel", "Groß"]
    
    var body: some View {
        NavigationStack {
            List(größen, id: \.self) { größe in
                HStack {
                    Text(größe)
                        .foregroundStyle(.black)
                    Spacer()
                    if größe == self.ausgewählteGröße {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewählteGröße = größe
                    showGroessenSheet = false
                }
            }
            .navigationTitle("Größe auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showGroessenSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    GroessenSheet(ausgewählteGröße: .constant(""), showGroessenSheet: .constant(true))
}
