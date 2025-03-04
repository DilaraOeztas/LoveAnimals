//
//  FarbenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct FarbenSheet: View {
    
    @Binding var ausgewählteFarbe: String
    @Binding var showFarbenSheet: Bool
    
    let farben = ["Schwarz", "Weiß", "Braun", "Grau", "Mehrfarbig", "Sonstiges"]
    
    var body: some View {
        NavigationStack {
            List(farben, id: \.self) { farbe in
                HStack {
                    Text(farbe)
                        .foregroundStyle(.black)
                    Spacer()
                    if farbe == self.ausgewählteFarbe {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewählteFarbe = farbe
                    showFarbenSheet = false
                }
            }
            .navigationTitle("Geschlecht auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showFarbenSheet = false
                    }
                }
            }
        }
    }
    
}

#Preview {
    FarbenSheet(ausgewählteFarbe: .constant(""), showFarbenSheet: .constant(true))
}



