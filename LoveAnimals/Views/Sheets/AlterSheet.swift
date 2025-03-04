//
//  AlterSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct AlterSheet: View {
    @Binding var ausgewählteAlter: String
    @Binding var showAlterSheet: Bool
    
    let alter = ["Jung", "Erwachsen", "Senior"]
    
    var body: some View {
        NavigationStack {
            List(alter, id: \.self) { alter in
                HStack {
                    Text(alter)
                        .foregroundStyle(.black)
                    Spacer()
                    if alter == self.ausgewählteAlter {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewählteAlter = alter
                    showAlterSheet = false
                }
            }
            .navigationTitle("Geschlecht auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showAlterSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    AlterSheet(ausgewählteAlter: .constant(""), showAlterSheet: .constant(true))
}






