//
//  DatenschutzView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 17.02.25.
//

import SwiftUI

struct DatenschutzView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Datenschutzerklärung")
                    .font(.title)
                    .bold()
                
                Text("""
                1. Verantwortliche Stelle:
                - Dilara Öztas
                - Pforzheimer Straße 251A, 70499 Stuttgart, bodur-dilara@hotmail.de

                2. Erhebung von Daten:
                - Tierheime: Name, Adresse, E-Mail, Telefonnummer, Zahlungsinformationen
                - Nutzer: Name, E-Mail, Favoriten

                3. Zweck der Datenverarbeitung:
                - Anzeigenverwaltung, Zahlungsabwicklung, Sicherheit.

                4. Speicherung & Sicherheit:
                - Daten werden 30 Tage nach Account-Löschung gelöscht.
                - Verschlüsselung und sichere Server.

                5. Rechte:
                - Nutzer können Daten einsehen, ändern oder löschen lassen.
                - Kontakt: bodur-dilara@hotmail.de
                """)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Datenschutz")
    }
}

#Preview {
    DatenschutzView()
}
