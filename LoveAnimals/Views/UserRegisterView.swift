//
//  UserRegisterView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 11.02.25.
//

import SwiftUI

struct UserRegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var keyboardObersver = KeyboardObserver()
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
    @State private var agbAccepted = false
    @State private var navigateToAgb: Bool = false
    @State private var navigateToDatenschutz: Bool = false
    
    
    var isOldEnough: Bool {
        let calendar = Calendar.current
        let today = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: today)
        return ageComponents.year ?? 0 >= 18
    }
    
    private var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && isOldEnough && !email.isEmpty && !postalCode.isEmpty && !city.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword && agbAccepted == true
    }
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    TextField("Vorname", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                    
                    TextField("Nachname", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                }
                
                
                TextField("E-Mail", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
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
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                
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
                        .autocorrectionDisabled(true)
                        .keyboardType(.asciiCapableNumberPad)
                        .frame(width: 100)
                        .padding(.horizontal)
                    
                    TextField("Wohnort", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                        .padding(.horizontal)
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
                        .onChange(of: birthdate) { _, newDate in
                            birthdate = newDate
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
                
                HStack {
                    Button(action: {
                        agbAccepted.toggle()
                    }) {
                        Image(systemName: agbAccepted ? "checkmark.square.fill" : "square")
                            .foregroundStyle(agbAccepted ? .blue : .gray)
                    }
                    Text(attributedTermsText)
                        .foregroundStyle(.primary)
                        .onTapGesture {
                            handleTapGesture()
                        }
                }
                .padding()
            }
            .padding(.bottom, 20)
                VStack {
                    Button(action: {
                        if isFormValid == true {
                            navigateToUserDetails = true
                        } else {
                            // Warnung anzeigen
                        }
                    }) {
                        Text("Weiter")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.brown)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .disabled(!isFormValid)
                            .opacity(isFormValid ? 1.0 : 0.5)
                    }
                    .navigationDestination(isPresented: $navigateToUserDetails) {
                        UserRegisterDetailsView(firstName: firstName, lastName: lastName, birthdate: birthdate, email: email, postalCode: postalCode, city: city, password: password)
                    }
                    
                    Button(action: {
                        navigateToLogin = true
                    }) {
                        Text("Bereits ein Konto? Hier einloggen")
                            .foregroundStyle(.blue)
                            .underline()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .navigationDestination(isPresented: $navigateToLogin) {
                        LoginView()
                    }
                }
                .padding(.horizontal)
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
        .padding(.top, 20)
        .navigationTitle("Registrierung")
        .navigationBarBackButtonHidden(true)
        
    }
        
    
    
    
    private var attributedTermsText: AttributedString {
        var text = AttributedString("Ich akzeptiere die AGB und die Datenschutzerklärung.")
        
        if let agbRange = text.range(of: "AGB") {
            text[agbRange].foregroundColor = .blue
            text[agbRange].underlineStyle = .single
            text[agbRange].link = URL(string: "app://navigateToAGB")
        }
        
        if let datenschutzRange = text.range(of: "Datenschutzerklärung") {
            text[datenschutzRange].foregroundColor = .blue
            text[datenschutzRange].underlineStyle = .single
            text[datenschutzRange].link = URL(string: "app://navigateToDatenschutz")
        }
        
        return text
    }
    
    private func handleTapGesture() {
        let text = attributedTermsText
        if let agbRange = text.range(of: "AGB"),
           text[agbRange].link == URL(string: "app://navigateToAGB") {
            navigateToAgb = true
        }
        
        if let datenschutzRange = text.range(of: "Datenschutzerklärung"),
           text[datenschutzRange].link == URL(string: "app://navigateToDatenschutz") {
            navigateToDatenschutz = true
        }
    }
}



#Preview {
    UserRegisterView()
        .environmentObject(AuthViewModel())
}
