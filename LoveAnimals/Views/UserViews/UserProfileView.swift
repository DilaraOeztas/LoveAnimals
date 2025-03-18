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
    @State private var profileImageUrl: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var postalCode: String = ""
    @State private var city: String = ""
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            VStack {
                if let profileImageUrl = userAuthViewModel.profileImageUrl {
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
                    if userAuthViewModel.profileImageUrl != nil {
                        userAuthViewModel.deleteProfileImage()
                    } else {
                        showImagePicker = true
                        userAuthViewModel.loadProfileImage()
                    }
                }) {
                    Text(userAuthViewModel.profileImageUrl != nil ? "Profilbild löschen" : "Profilbild hinzufügen")
                        .foregroundStyle(userAuthViewModel.profileImageUrl != nil ? .red : .blue)
                }
                .padding()
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        userAuthViewModel.profileImage = image
                        userAuthViewModel.uploadProfileImage()
                    }
                }
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
