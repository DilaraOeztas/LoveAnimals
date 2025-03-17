//
//  ThContactView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI
import MessageUI

struct ContactView: View {
    let supportEmail = "support@example.com"
    let supportPhone = "+49 123 456789"

    var body: some View {
        Form {
            Section(header: Text("Kontaktmöglichkeiten")) {
                Button("E-Mail senden") {
                    if let url = URL(string: "mailto:\(supportEmail)") {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Anrufen") {
                    if let url = URL(string: "tel:\(supportPhone)") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
        .navigationTitle("Kontakt")
    }
}
