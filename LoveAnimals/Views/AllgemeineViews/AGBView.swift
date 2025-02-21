//
//  AGBView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 17.02.25.
//

import SwiftUI

struct AGBView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Allgemeine Geschäftsbedingungen (AGB)")
                .font(.title)
                .bold()
            
            VStack {
                Text("""
                1. Geltungsbereich
                Diese Allgemeinen Geschäftsbedingungen (AGB) regeln die Nutzung der LoveAnimals-App...
                
                2. Leistungen
                - Kostenloses Basis-Abo: 5 Tiere pro Monat
                - Premium-Abo: 4,99 € pro Monat
                - Top-Anzeige: 1,99 € pro Woche
                
                3. Vertragsabschluss & Kündigung
                - Das Abo kann jederzeit über den App Store gekündigt werden.
                - Bereits gezahlte Beträge werden nicht erstattet.
                
                4. Datenschutz
                Siehe Datenschutzerklärung.
                """)
            }
            .padding(.top, 20)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    AGBView()
}
