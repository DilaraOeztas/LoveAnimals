//
//  FarbenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct FarbenSheet: View {
    @ObservedObject var viewModel: TierEinstellenViewModel
    @Binding var ausgewaehlteFarbe: String
    @Binding var showFarbenSheet: Bool
    @State private var benutzerdefinierteFarbe: String = ""
    @State private var eigeneFarbeGespeichert: Bool = false
    @State private var showCustomAlert: Bool = false
    
    var farben: [String] {
        let standardFarben = ["Schwarz", "Weiß", "Braun", "Grau", "Mehrfarbig"]
        let gespeicherteFarbe = viewModel.benutzerdefinierteFarben
        var liste = standardFarben + gespeicherteFarbe
        if eigeneFarbeGespeichert, !viewModel.neueFarbe.isEmpty {
            liste.append(viewModel.neueFarbe)
        }
        return liste
    }
    
    var body: some View {
        NavigationStack {
            List(Array(Set(farben)), id: \.self) { farbe in
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
                ToolbarItem(placement: .topBarTrailing) {
                    if eigeneFarbeGespeichert {
                        Button("Fertig") {
                            showFarbenSheet = false
                        }
                    } else {
                        Button("Hinzufügen") {
                            showCustomAlert = true
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        benutzerdefinierteFarbe = ""
                        showFarbenSheet = false
                    }
                }
            }
            .alert("Farbe eingeben", isPresented: $showCustomAlert) {
                TextField("Farbe", text: $benutzerdefinierteFarbe)
                Button("Speichern", action: speichereEigeneFarbe)
                Button("Abbrechen", role: .cancel) { }
            }
            .onAppear {
                Task {
                    await viewModel.ladeBenutzerdefinierteFarben()
                }
            }
        }
    }
    
    private func speichereEigeneFarbe() {
        guard !benutzerdefinierteFarbe.isEmpty else { return }
        viewModel.neueFarbe = benutzerdefinierteFarbe
        ausgewaehlteFarbe = benutzerdefinierteFarbe
        benutzerdefinierteFarbe = ""
        eigeneFarbeGespeichert = true
    }
}

#Preview {
    FarbenSheet(viewModel: TierEinstellenViewModel(), ausgewaehlteFarbe: .constant(""), showFarbenSheet: .constant(true))
        .environmentObject(TierEinstellenViewModel())
}



