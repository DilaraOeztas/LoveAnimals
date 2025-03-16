//
//  TierheimSettingsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct TierheimSettingsView: View {
    @State private var paymentOptions = ["Barzahlung", "Überweisung"]
    @State private var selectedPayment = "Barzahlung"
    @State private var donationEnabled = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Öffnungszeiten")) {
                    NavigationLink("Bearbeiten", destination: EditOeffnungszeitenView())
                }
                
                Section(header: Text("Zahlungsmethoden")) {
                    Picker("Zahlungsart", selection: $selectedPayment) {
                        ForEach(paymentOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Spenden")) {
                    Toggle("Spenden akzeptieren", isOn: $donationEnabled)
                }
                
                Section(header: Text("Abo-Status")) {
                    Text("Aktuelles Abo: Premium")
                        .foregroundStyle(.green)
                }
            }
            .navigationTitle("Tierheim-Einstellungen")
        }
    }
}
