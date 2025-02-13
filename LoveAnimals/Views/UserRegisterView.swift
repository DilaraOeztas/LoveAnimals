//
//  UserRegisterView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 11.02.25.
//

import SwiftUI

struct UserRegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthdate: Date = Calendar.current.date(
        byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var isTooYoung: Bool = false
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword: Bool = false
    @State private var postalCode = ""
    @State private var city = ""
    @State private var searchRadius: Double = 10
    @State private var navigateToLogin: Bool = false
    @State private var navigateToUserDetails: Bool = false
    
    var isOldEnough: Bool {
        let calendar = Calendar.current
        let today = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: today)
        return ageComponents.year ?? 0 >= 18
    }
    
    
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    TextField("Vorname", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocorrectionDisabled(true)
                    
                    TextField("Nachname", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocorrectionDisabled(true)
                }
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Geburtsdatum")
                        
                        Spacer()
                        DatePicker("Wähle dein Geburtsdatum",
                                   selection: $birthdate,
                                   in: ...Date(),
                                   displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "de_DE"))
                        .onChange(of: birthdate) { _, _ in
                            isTooYoung = !isOldEnough
                        }
                    }
                    if isTooYoung {
                        Text("Du musst mindestens 18 Jahre alt sein")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                    
                }
                .padding(.horizontal)
                
                TextField("E-Mail", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                Group {
                    if showPassword {
                        TextField("Passwort", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("Passwort", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    if showPassword {
                        TextField("Passwort bestätigen", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("Passwort bestätigen", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "checkmark.square" : "square")
                            .foregroundStyle(showPassword ? .black : .black)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Text("Passwort anzeigen")
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    TextField("PLZ", text: $postalCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .padding(.horizontal)
                    
                    TextField("Wohnort", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("In welchem Umkreis möchtest du nach Tierheimen suchen?")
                        .font(.subheadline)
                        .padding(.horizontal)
                    
                    Slider(value: $searchRadius, in: 1...100, step: 1)
                        .padding(.horizontal)
                    
                    Text("\(Int(searchRadius)) km Umkreis")
                        .font(.headline)
                        .padding(.horizontal)
                }
                    .padding(.bottom, 20)
                
                
                Button(action: {
                    Task {
                        await authViewModel.register(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: password,
                            birthdate: birthdate,
                            signedUpOn: Date()
                        )
                        navigateToUserDetails = true
                    }
                }) {
                    Text("Weiter")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.brown)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $navigateToUserDetails) {
                    UserRegisterDetailsView()
                }
                
                Button(action: {
                    navigateToLogin = true
                }) {
                    Text("Bereits ein Konto? Hier einloggen")
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding(.top, 10)
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .padding(.top, 20)
        .navigationTitle("Registrierung")
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    UserRegisterView()
        .environmentObject(AuthViewModel())
}
