//
//  ThNotificationView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct ThNotificationView: View {
    @State private var pushNotificationsEnabled = true
    @State private var emailNotificationsEnabled = false

    var body: some View {
        Form {
            Section(header: Text("Benachrichtigungen")) {
                Toggle("Push-Benachrichtigungen", isOn: $pushNotificationsEnabled)
                Toggle("E-Mail-Benachrichtigungen", isOn: $emailNotificationsEnabled)
            }
        }
        .navigationTitle("Benachrichtigungen")
    }
}
