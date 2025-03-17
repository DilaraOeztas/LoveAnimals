//
//  AppBewertenView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct AppBewertenView: View {
    let appStoreURL = "https://apps.apple.com/app/id123456789" 

    var body: some View {
        VStack {
            Text("Gefällt dir die App?")
                .font(.headline)
                .padding()

            Button("App bewerten") {
                if let url = URL(string: appStoreURL) {
                    UIApplication.shared.open(url)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        .navigationTitle("App bewerten")
    }
}
