//
//  GroessenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct GroessenSheet: View {
    @Binding var ausgewaehlteGroesse: String
    @Binding var showGroessenSheet: Bool
    
    let groessenAngaben = [
        ("Klein", "< 30 cm"),
        ("Mittel", "30-60 cm"),
        ("Groß", "> 60 cm")
    ]
    
    var body: some View {
        NavigationStack {
            List(groessenAngaben, id: \.0) { groesse, beschreibung in
                HStack {
                    Text(groesse)
                        .foregroundStyle(.black)
                    Spacer()
                    Text(beschreibung)
                        .foregroundStyle(.gray)
                    if groesse == ausgewaehlteGroesse {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewaehlteGroesse = groesse
                    showGroessenSheet = false
                }
            }
            .navigationTitle("Größe wählen")
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
    GroessenSheet(ausgewaehlteGroesse: .constant(""), showGroessenSheet: .constant(true))
}
