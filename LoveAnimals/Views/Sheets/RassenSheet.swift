//
//  RassenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI
import FirebaseFirestore

struct RassenSheet: View {
    @ObservedObject var viewModel: TierEinstellenViewModel
    @Binding var ausgewaehlteRasse: String
    @Binding var showRasseSheet: Bool
    var tierartIstBenutzerdefiniert: Bool
    @State private var benutzerdefinierteRasse: String = ""
    @State private var eigeneRasseGespeichert : Bool = false
    @State private var showCustomAlert: Bool = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if (Tierart(rawValue: viewModel.ausgewaehlteTierart)?.rassen().isEmpty ?? true) && viewModel.aktuelleRassen.isEmpty {
                    Text("Es wurden noch keine Rassen für diese Tierart definiert.")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } 
                List {
                    ForEach(Array(Set(viewModel.aktuelleRassen)), id: \.self) { rasse in
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
                            if rasse == "Sonstige" || tierartIstBenutzerdefiniert {
                                showCustomAlert = true
                            } else {
                                ausgewaehlteRasse = rasse
                                showRasseSheet = false
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Rasse wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if eigeneRasseGespeichert {
                        Button("Fertig") {
                            showRasseSheet = false
                        }
                    } else {
                        Button("Hinzufügen") {
                            showCustomAlert = true
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        benutzerdefinierteRasse = ""
                        showRasseSheet = false
                    }
                }
            }
            .alert("Eigene Rasse eingeben", isPresented: $showCustomAlert) {
                TextField("Rasse", text: $benutzerdefinierteRasse)
                Button("Speichern", action: speichereEigeneRasse)
                Button("Abbrechen", role: .cancel) {}
            }
            .onAppear {
                Task {
                    await viewModel.ladeRassenFuerTierart(tierart: viewModel.ausgewaehlteTierart)
                }
            }
        }
    }
    
    
    private func speichereEigeneRasse() {
        guard !benutzerdefinierteRasse.isEmpty else { return }
        
        Task {
            await viewModel.speichereBenutzerdefinierteTierart(
                neueTierart: viewModel.ausgewaehlteTierart,
                neueRasse: benutzerdefinierteRasse
            )
            benutzerdefinierteRasse = ""
            eigeneRasseGespeichert = true
        }
    }
    
}

//#Preview {
//    RassenSheet(rassen: .constant(["Mischling", "Schäferhund"]), ausgewaehlteRasse: .constant("Mischling"), showRasseSheet: .constant(true), tierartIstBenutzerdefiniert: true)
//}
