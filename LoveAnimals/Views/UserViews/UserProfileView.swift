//
//  UserProfileView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct UserProfileView: View {
    @State private var name = "Max Mustermann"
    @State private var email = "max@example.com"
    @State private var phone = "+49 123 456789"
    @State private var profileImage: UIImage? = nil
    @State private var showImagePicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundStyle(.gray)
                        }
                        Button("Profilbild ändern") {
                            showImagePicker = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Section(header: Text("Persönliche Daten")) {
                    TextField("Name", text: $name)
                    TextField("E-Mail", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Telefonnummer", text: $phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Profil")
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.profileImage = image
            }
        }
    }
}
