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
    @State private var showCustomAlert: Bool = false
    
    var tierarten: [String] {
        let standardTierarten = ["Hund", "Katze", "Vogel", "Kaninchen", "Reptil", "Fisch", "Sonstiges"]
        let gespeicherteTierarten = viewModel.benutzerdefinierteTierarten.keys.sorted()
        var liste = standardTierarten + gespeicherteTierarten
        if !viewModel.neueTierart.isEmpty {
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") {
                        if !viewModel.neueTierart.isEmpty {
                            ausgewaehlteTierart = viewModel.neueTierart
                            viewModel.neueTierart = ""
                        }
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
        benutzerdefinierteTierart = ""
    }
}

#Preview {
    TierartSheet(viewModel: TierEinstellenViewModel(), ausgewaehlteTierart: .constant(""), showTierartSheet: .constant(true))
        .environmentObject(TierEinstellenViewModel())
}
