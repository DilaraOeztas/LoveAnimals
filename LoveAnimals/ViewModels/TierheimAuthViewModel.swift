//
//  TierheimAuthViewModel.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 19.02.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class TierheimAuthViewModel: ObservableObject {
    @Published var tierheimName = ""
    @Published var straße = ""
    @Published var plz: String = ""
    @Published var ort = ""
    @Published var telefonnummer = ""
    @Published var email = ""
    @Published var homepage = ""
    @Published var akzeptiertBarzahlung = false
    @Published var akzeptiertÜberweisung = false
    @Published var empfaengername: String = ""
    @Published var iban = ""
    @Published var bic = ""
    @Published var nimmtSpendenAn = false
    @Published var spendenIban = ""
    @Published var spendenBic = ""
    @Published var verfügbareTage: [String: Bool] = [
        "Montag": false, "Dienstag": false, "Mittwoch": false,
        "Donnerstag": false, "Freitag": false, "Samstag": false
    ]
    @Published var öffnungszeiten: [String: Öffnungszeit] = [:]
    @Published var selectedDay: String?
    @Published var showTimePicker: Bool = false
    @Published var passwort = ""
    @Published var confirmPasswort = ""
    @Published var isLoading = false
    @Published var navigateToHome = false

    func registerTierheim() {
        guard passwort == confirmPasswort else {
            print("Passwörter stimmen nicht überein")
            return
        }

        isLoading = true

        Auth.auth().createUser(withEmail: email, password: passwort) { authResult, error in
            if let error = error {
                print("Fehler beim Registrieren: \(error.localizedDescription)")
                self.isLoading = false
                return
            }

            guard let userID = authResult?.user.uid else {
                self.isLoading = false
                return
            }

            let tierheimDaten: [String: Any] = [
                "tierheimName": self.tierheimName,
                "straße": self.straße,
                "telefonnummer": self.telefonnummer,
                "email": self.email,
                "homepage": self.homepage,
                "akzeptiertBarzahlung": self.akzeptiertBarzahlung,
                "akzeptiertÜberweisung": self.akzeptiertÜberweisung,
                "iban": self.akzeptiertÜberweisung ? self.iban : "",
                "bic": self.akzeptiertÜberweisung ? self.bic : "",
                "nimmtSpendenAn": self.nimmtSpendenAn,
                "spendenIban": self.nimmtSpendenAn ? (self.akzeptiertÜberweisung ? self.iban : self.spendenIban) : "",
                "spendenBic": self.nimmtSpendenAn ? (self.akzeptiertÜberweisung ? self.bic : self.spendenBic) : "",
                "öffnungszeiten": self.öffnungszeiten.reduce(into: [String: [String: Any]]()) { result, entry in
                    result[entry.key] = ["von": Timestamp(date: entry.value.von), "bis": Timestamp(date: entry.value.bis)]
                },
                "createdAt": Timestamp(date: Date())
            ]

            Firestore.firestore().collection("tierheime").document(userID).setData(tierheimDaten) { error in
                if let error = error {
                    print("Fehler beim Speichern in Firestore: \(error.localizedDescription)")
                    self.isLoading = false
                } else {
                    print("Tierheim erfolgreich registriert!")
                    DispatchQueue.main.async {
                        self.navigateToHome = true
                    }
                }
            }
        }
    }
}
