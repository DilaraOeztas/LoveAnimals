//
//  FarbenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct FarbenSheet: View {
    
    @Binding var ausgewaehlteFarbe: String
    @Binding var showFarbenSheet: Bool
    
    let farben = ["Schwarz", "Weiß", "Braun", "Grau", "Mehrfarbig", "Sonstiges"]
    
    var body: some View {
        NavigationStack {
            List(farben, id: \.self) { farbe in
                HStack {
                    Text(farbe)
                        .foregroundStyle(.black)
                    Spacer()
                    if farbe == ausgewaehlteFarbe {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewaehlteFarbe = farbe
                    showFarbenSheet = false
                }
            }
            .navigationTitle("Farbe wählen")
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
    FarbenSheet(ausgewaehlteFarbe: .constant(""), showFarbenSheet: .constant(true))
}



