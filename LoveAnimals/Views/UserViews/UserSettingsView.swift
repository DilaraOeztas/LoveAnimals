//
//  UserSettingsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI
import UserNotifications

struct UserSettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var notificationsEnabled = true
    @State private var showProfileEditor = false
    @State private var showChangePassword = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Benutzer")) {
                    Button("Profil bearbeiten") {
                        showProfileEditor.toggle()
                    }
                    
                    Button("Passwort ändern") {
                        showChangePassword.toggle()
                    }
                }
                
                Section(header: Text("Einstellungen")) {
                    Toggle("Benachrichtigungen", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { _, newValue in
                            if newValue {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                    if let error = error {
                                        print("Fehler bei Benachrichtigungsberechtigung: \(error.localizedDescription)")
                                    } else {
                                        DispatchQueue.main.async {
                                            notificationsEnabled = granted
                                        }
                                    }
                                }
                            }
                        }
                    
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _, newValue in
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = scene.windows.first {
                                window.overrideUserInterfaceStyle = newValue ? .dark : .light
                            }
                        }
                }
                
                Section(header: Text("Datenschutz & Sicherheit")) {
                    NavigationLink("Berechtigungen verwalten", destination: PermissionsView())
                }
            }
            .navigationTitle("Einstellungen")
            .sheet(isPresented: $showProfileEditor) {
                ProfileEditView()
            }
            .sheet(isPresented: $showChangePassword) {
                ChangePasswordView()
            }
        }
    }
}
