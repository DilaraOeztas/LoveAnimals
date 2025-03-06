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
    
    let groessen = ["Klein", "Mittel", "Groß"]
    
    var body: some View {
        NavigationStack {
            List(groessen, id: \.self) { groesse in
                HStack {
                    Text(groesse)
                        .foregroundStyle(.black)
                    Spacer()
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
    GroessenSheet(ausgewaehlteGroesse: .constant(""), showGroessenSheet: .constant(true))
}
