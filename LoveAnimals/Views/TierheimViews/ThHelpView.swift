//
//  ThHelpView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct ThHelpView: View {
    var body: some View {
        Form {
            Section(header: Text("Hilfe & Support")) {
                NavigationLink("Häufige Fragen (FAQ)", destination: Text("Hier können FAQ angezeigt werden."))
                NavigationLink("Support kontaktieren", destination: Text("Hier kommt der Support-Bereich."))
            }
        }
        .navigationTitle("Hilfebereich")
    }
}
