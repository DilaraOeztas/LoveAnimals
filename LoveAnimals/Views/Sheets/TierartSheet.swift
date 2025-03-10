//
//  TierartSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct TierartSheet: View {
    @Binding var ausgewaehlteTierart: String
    @Binding var showTierartSheet: Bool
    @State private var benutzerdefinierteTierart: String = ""
    @State private var showCustomAlert: Bool = false
    
    let tierarten = ["Hund", "Katze", "Vogel", "Kaninchen", "Meerschweinchen", "Reptil", "Fisch", "Sonstiges"]
    
    var body: some View {
        NavigationStack {
            List(tierarten, id: \.self) { tierart in
                HStack {
                    Text(tierart)
                        .foregroundStyle(.black)
                    Spacer()
                    if tierart == ausgewaehlteTierart {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if tierart == "Sonstiges" {
                        showCustomAlert = true
                    } else {
                        ausgewaehlteTierart = tierart
                        showTierartSheet = false
                    }
                }
            }
            .navigationTitle("Tierart wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showTierartSheet = false
                    }
                }
            }
            .alert("Tierart eingeben", isPresented: $showCustomAlert) {
                TextField("Tierart", text: $benutzerdefinierteTierart)
                Button("Speichern", action: speichereEigeneTierart)
                Button("Abbrechen", role: .cancel) { }
            }
        }
    }
    
    private func speichereEigeneTierart() {
        if !benutzerdefinierteTierart.isEmpty {
            ausgewaehlteTierart = benutzerdefinierteTierart
            showTierartSheet = false
        }
    }
}



#Preview {
    TierartSheet(ausgewaehlteTierart: .constant(""), showTierartSheet: .constant(true))
}
