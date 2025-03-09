//
//  RassenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct RassenSheet: View {
    let rassen: [String]
    @Binding var ausgewaehlteRasse: String
    @Binding var showRasseSheet: Bool
    @State private var benutzerdefinierteRasse: String = ""
    @State private var showCustomAlert: Bool = false

    var body: some View {
        NavigationStack {
            List(rassen, id: \.self) { rasse in
                HStack {
                    Text(rasse)
                        .foregroundStyle(.black)
                    Spacer()
                    if rasse == ausgewaehlteRasse {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if rasse == "Sonstige" {
                        showCustomAlert = true
                    } else {
                        ausgewaehlteRasse = rasse
                        showRasseSheet = false
                    }
                }
            }
            .navigationTitle("Rasse wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showRasseSheet = false
                    }
                }
            }
            .alert("Eigene Rasse eingeben", isPresented: $showCustomAlert) {
                TextField("Rasse", text: $benutzerdefinierteRasse)
                Button("Speichern", action: speichereEigeneRasse)
                Button("Abbrechen", role: .cancel) {}
            }
        }
    }

    private func speichereEigeneRasse() {
        if !benutzerdefinierteRasse.isEmpty {
            ausgewaehlteRasse = benutzerdefinierteRasse
            showRasseSheet = false
        }
    }
}

#Preview {
    RassenSheet(rassen: ["Mischling", "Schäferhund"], ausgewaehlteRasse: .constant("Mischling"), showRasseSheet: .constant(true))
}
