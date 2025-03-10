//
//  RassenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct RassenSheet: View {
    @Binding var rassen: [String]
    @Binding var ausgewaehlteRasse: String
    @Binding var showRasseSheet: Bool
    @State private var benutzerdefinierteRasse: String = ""
    @State private var eigeneRasseGespeichert : Bool = false
    @State private var showCustomAlert: Bool = false
    var tierartIstBenutzerdefiniert: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                if rassen.isEmpty && tierartIstBenutzerdefiniert {
                    Text("Es wurden noch keine Rassen für diese Tierart definiert.")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    List {
                        ForEach(rassen, id: \.self) { rasse in
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
                        ausgewaehlteRasse = ""
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
        guard !benutzerdefinierteRasse.isEmpty else { return }
        if !rassen.contains(benutzerdefinierteRasse) {
            rassen.append(benutzerdefinierteRasse)
        }
        ausgewaehlteRasse = benutzerdefinierteRasse
        benutzerdefinierteRasse = ""
        eigeneRasseGespeichert = true
    }
    
}

#Preview {
    RassenSheet(rassen: .constant(["Mischling", "Schäferhund"]), ausgewaehlteRasse: .constant("Mischling"), showRasseSheet: .constant(true), tierartIstBenutzerdefiniert: true)
}
