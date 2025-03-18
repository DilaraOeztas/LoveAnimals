//
//  ThProfileView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ThProfileView: View {
    @ObservedObject var tierheimViewModel: TierheimAuthViewModel
    @State private var showImagePicker = false
    @State private var profileImageUrl: String = ""
    @State private var tierheimName: String = ""
    @State private var email: String = ""
    @State private var homepage: String = ""
    @State private var telefon: String = ""
    @State private var straße: String = ""
    @State private var plz: String = ""
    @State private var ort: String = ""
    @State private var isEditing = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if let profileImageUrl = tierheimViewModel.profileImageUrl {
                    AsyncImage(url: URL(string: profileImageUrl)) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 2)))
                        .foregroundStyle(.gray)
                }
                
                
                Button(action: {
                    if tierheimViewModel.profileImageUrl != nil {
                        tierheimViewModel.deleteProfileImage()
                    } else {
                        showImagePicker = true
                        tierheimViewModel.loadProfileImage()
                    }
                }) {
                    Text(tierheimViewModel.profileImageUrl != nil ? "Profilbild löschen" : "Profilbild hinzufügen")
                        .foregroundStyle(tierheimViewModel.profileImageUrl != nil ? .red : .blue)
                }
                .padding()
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        tierheimViewModel.profileImage = image
                        tierheimViewModel.uploadProfileImage()
                    }
                }
                Form {
                    Section(header: Text("Persönliche Daten")) {
                        TextField("Name", text: $tierheimName)
                            .disabled(!isEditing)
                        TextField("E-Mail", text: $email)
                            .disabled(!isEditing)
                        TextField("Homepage", text: $homepage)
                            .disabled(!isEditing)
                        TextField("Telefon", text: $telefon)
                            .disabled(!isEditing)
                        TextField("Straße", text: $straße)
                            .disabled(!isEditing)
                        TextField("PLZ", text: $plz)
                            .disabled(!isEditing)
                        TextField("Ort", text: $ort)
                            .disabled(!isEditing)
                    }
                    
                    Button(action: {
                        if isEditing {
                            tierheimViewModel.updateTierheimDaten(
                                tierheimName: tierheimName,
                                email: email,
                                homepage: homepage,
                                telefon: telefon,
                                straße: straße,
                                plz: plz,
                                ort: ort
                            )
                        }
                        isEditing.toggle()
                    }) {
                        HStack {
                            Image(systemName: "pencil.circle.fill")
                            Text(isEditing ? "Speichern" : "Bearbeiten")
                        }
                        .padding()
                        .foregroundStyle(.blue)
                    }
                }
            }
            .navigationTitle("Profil")
            .onAppear {
                loadData()
                tierheimViewModel.loadProfileImage()
            }
            
        }
    }
    
    private func loadData() {
        if let tierheimID = tierheimViewModel.userId {
            tierheimViewModel.ladeTierheimDaten(tierheimID: tierheimID)
        }
        
        tierheimName = tierheimViewModel.tierheim?.tierheimName ?? ""
        email = tierheimViewModel.tierheim?.email ?? ""
        homepage = tierheimViewModel.tierheim?.homepage ?? ""
        telefon = tierheimViewModel.tierheim?.telefon ?? ""
        straße = tierheimViewModel.tierheim?.straße ?? ""
        plz = tierheimViewModel.tierheim?.plz ?? ""
        ort = tierheimViewModel.tierheim?.ort ?? ""
    }
    

}

