//
//  ThProfileEditView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI
import PhotosUI

struct ThProfileEditView: View {
    @State private var name = "Max Mustermann"
    @State private var email = "max@example.com"
    @State private var phone = "+49 123 456789"
    
    @State private var profileImage: UIImage? = UIImage(systemName: "person.circle.fill")
    @State private var showImagePicker = false
    @State private var selectedImage: PhotosPickerItem?
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .padding(.bottom, 5)
                        }
                        
                        HStack {
                            Button("Ändern") {
                                showImagePicker = true
                            }
                            .buttonStyle(.bordered)

                            Button("Entfernen") {
                                profileImage = UIImage(systemName: "person.circle.fill")
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                
                Section(header: Text("Persönliche Daten")) {
                    TextField("Name", text: $name)
                    TextField("E-Mail", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Telefonnummer", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section {
                    Button("Speichern") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Profil bearbeiten")
            .navigationBarItems(trailing: Button("Abbrechen") {
                dismiss()
            })
            .photosPicker(isPresented: $showImagePicker, selection: $selectedImage, matching: .images)
            .onChange(of: selectedImage) { _, newItem in
                if let newItem = newItem {
                    loadImage(from: newItem)
                }
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                profileImage = uiImage
            }
        }
    }
}

