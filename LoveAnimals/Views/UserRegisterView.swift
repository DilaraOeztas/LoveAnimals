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
    @State private var birthdate: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
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
        
        VStack {
            Text("Registrierung")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
                .padding(.bottom, 40)
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
                            DatePicker("Wähle dein Geburtsdatum", selection: $birthdate, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .environment(\.locale, Locale(identifier: "de_DE"))
                                .onChange(of: birthdate) { oldValue, newValue in
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
                                .foregroundStyle(showPassword ? .blue : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Text("Passwort anzeigen")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    
                    HStack {
                        TextField("PLZ", text: $postalCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .padding(.horizontal)
                        
                        TextField("Wohnort", text: $city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("In welchem Umkreis möchtest du nach Tierheimen suchen?")
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.subheadline)
                            .padding(.horizontal)
                        
                        Slider(value: $searchRadius, in: 1...100, step: 1)
                            .padding(.horizontal)
                        
                        Text("\(Int(searchRadius)) km Umkreis")
                            .font(.headline)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                        .padding(.top, 20)
                    
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
                    .padding(.bottom, 20)
                    .navigationDestination(isPresented: $navigateToUserDetails) {
                        UserDetailsView()
                    }
                    
                    Button(action: {
                        navigateToLogin = true
                    }) {
                        Text("Bereits ein Konto? Hier einloggen")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding(.bottom, 40)
                    .navigationDestination(isPresented: $navigateToLogin){
                        LoginView()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    UserRegisterView()
        .environmentObject(AuthViewModel())
}

