//
//  UserProfileView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var userAuthViewModel: UserAuthViewModel
    @State private var showImagePicker = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var postalCode: String = ""
    @State private var city: String = ""
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if !userAuthViewModel.profileImageUrl.isEmpty {
                    AsyncImage(url: URL(string: userAuthViewModel.profileImageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(width: 120, height: 120)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .foregroundStyle(.gray)
                }
                
                HStack {
                    if userAuthViewModel.profileImageUrl.isEmpty {
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Profilbild hinzufügen")
                                .foregroundStyle(.blue)
                        }
                    } else {
                        Button(action: {
                            userAuthViewModel.deleteProfileImage()
                        }) {
                            Text("Löschen")
                                .foregroundStyle(.red)
                        }
                        Text("/")
                            .foregroundStyle(.gray)
                        Button(action: {
                            showImagePicker = true
                            userAuthViewModel.loadProfileImage()
                        }) {
                            Text("Ändern")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                
                .padding()
                
                Form {
                    Section(header: Text("Persönliche Daten")) {
                        TextField("Name", text: $firstName)
                            .disabled(!isEditing)
                        TextField("Nachname", text: $lastName)
                            .disabled(!isEditing)
                        TextField("E-Mail", text: $email)
                            .disabled(!isEditing)
                        TextField("Postleitzahl", text: $postalCode)
                            .disabled(!isEditing)
                        TextField("Stadt", text: $city)
                            .disabled(!isEditing)
                    }
                    
                    Button(action: {
                        if isEditing {
                            userAuthViewModel.updateUserDaten(
                                firstName: firstName,
                                lastName: lastName,
                                email: email,
                                postalCode: postalCode,
                                city: city
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
                userAuthViewModel.loadProfileImage()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(sourceType: .photoLibrary) { image in
                    userAuthViewModel.profileImage = image
                    userAuthViewModel.uploadProfileImage()
                }
            }
            
        }
    }
    
    private func loadData() {
        if let userId = userAuthViewModel.userID {
            userAuthViewModel.ladeUserDaten(userID: userId)
        }
        
        firstName = userAuthViewModel.fireUser?.firstName ?? ""
        lastName = userAuthViewModel.fireUser?.lastName ?? ""
        email = userAuthViewModel.fireUser?.email ?? ""
        postalCode = userAuthViewModel.fireUser?.postalCode ?? ""
        city = userAuthViewModel.fireUser?.city ?? ""
    }
    
    
}
