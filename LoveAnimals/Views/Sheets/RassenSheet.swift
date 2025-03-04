//
//  RassenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct RassenSheet: View {
    let rassen: [String]
    @Binding var ausgewählteRasse: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(rassen, id: \.self) { rasse in
                HStack {
                    Text(rasse)
                    Spacer()
                    if ausgewählteRasse == rasse {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                            
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewählteRasse = rasse
                }
            }
            .navigationBarTitle("Rasse wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RassenSheet(rassen: ["Mischling", "Schäferhund"], ausgewählteRasse: .constant("Mischling"))
}
