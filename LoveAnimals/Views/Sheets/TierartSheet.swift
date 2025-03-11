//
//  TierartSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct TierartSheet: View {
    @ObservedObject var viewModel: TierEinstellenViewModel
    @Binding var ausgewaehlteTierart: String
    @Binding var showTierartSheet: Bool
    @State private var benutzerdefinierteTierart: String = ""
    @State private var eigeneTierartGespeichert: Bool = false
    @State private var showCustomAlert: Bool = false
    
    var tierarten: [String] {
        let standardTierarten = ["Hund", "Katze", "Vogel", "Kaninchen", "Reptil", "Fisch"]
        let gespeicherteTierarten = viewModel.benutzerdefinierteTierarten.keys.sorted()
        var liste = standardTierarten + gespeicherteTierarten
        if eigeneTierartGespeichert, !viewModel.neueTierart.isEmpty {
            liste.append(viewModel.neueTierart)
        }
        return liste
    }
    
    var body: some View {
        NavigationStack {
            List(Array(Set(tierarten)), id: \.self) { tierart in
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
                    ausgewaehlteTierart = tierart
                    showTierartSheet = false
                }
            }
            .navigationTitle("Tierart wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if eigeneTierartGespeichert {
                        Button("Fertig") {
                            showTierartSheet = false
                        }
                    } else {
                        Button("Hinzufügen") {
                            showCustomAlert = true
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        benutzerdefinierteTierart = ""
                        showTierartSheet = false
                    }
                }
            }
            .alert("Tierart eingeben", isPresented: $showCustomAlert) {
                TextField("Tierart", text: $benutzerdefinierteTierart)
                Button("Speichern", action: speichereEigeneTierart)
                Button("Abbrechen", role: .cancel) { }
            }
            .onAppear {
                Task {
                    await viewModel.ladeBenutzerdefinierteTierarten()
                }
            }
        }
    }
    
    private func speichereEigeneTierart() {
        guard !benutzerdefinierteTierart.isEmpty else { return }
        viewModel.neueTierart = benutzerdefinierteTierart
        ausgewaehlteTierart = benutzerdefinierteTierart
        benutzerdefinierteTierart = ""
        eigeneTierartGespeichert = true
    }
}

#Preview {
    TierartSheet(viewModel: TierEinstellenViewModel(), ausgewaehlteTierart: .constant(""), showTierartSheet: .constant(true))
        .environmentObject(TierEinstellenViewModel())
}
