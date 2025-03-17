//
//  ChangePasswortView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Neues Passwort setzen")) {
                    SecureField("Aktuelles Passwort", text: $currentPassword)
                    SecureField("Neues Passwort", text: $newPassword)
                    SecureField("Passwort bestätigen", text: $confirmPassword)
                }
                
                Section {
                    Button("Passwort ändern") {
                        dismiss()
                    }
                    .disabled(newPassword.isEmpty || newPassword != confirmPassword)
                }
            }
            .navigationTitle("Passwort ändern")
            .navigationBarItems(trailing: Button("Abbrechen") {
                dismiss()
            })
        }
    }
}
