//
//  EditOeffnungszeitenView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct EditOeffnungszeitenView: View {
    @State private var openingHours: [String: String] = [
        "Montag": "09:00 - 18:00",
        "Dienstag": "09:00 - 18:00",
        "Mittwoch": "09:00 - 18:00",
        "Donnerstag": "09:00 - 18:00",
        "Freitag": "09:00 - 18:00",
        "Samstag": "10:00 - 14:00",
        "Sonntag": "Geschlossen"
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Öffnungszeiten bearbeiten")) {
                ForEach(openingHours.keys.sorted(), id: \.self) { day in
                    HStack {
                        Text(day)
                        Spacer()
                        TextField("z. B. 09:00 - 18:00", text: Binding(
                            get: { self.openingHours[day] ?? "" },
                            set: { self.openingHours[day] = $0 }
                        ))
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            
            Button(action: saveOpeningHours) {
                Text("Speichern")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Öffnungszeiten")
    }
    
    func saveOpeningHours() {
        print("Neue Öffnungszeiten gespeichert: \(openingHours)")
    }
}


