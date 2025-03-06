//
//  GeschlechtSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct GeschlechtSheet: View {
    @Binding var ausgewaehltesGeschlecht: String
    @Binding var showSheet: Bool
    
    let geschlechter = ["Männlich", "Weiblich"]
    
    var body: some View {
        NavigationStack {
            List(geschlechter, id: \.self) { geschlecht in
                HStack {
                    Text(geschlecht)
                        .foregroundStyle(.black)
                    Spacer()
                    if geschlecht == ausgewaehltesGeschlecht {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewaehltesGeschlecht = geschlecht
                    showSheet = false
                }
            }
            .navigationTitle("Geschlecht auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    GeschlechtSheet(ausgewaehltesGeschlecht: .constant(""), showSheet: .constant(true))
}
