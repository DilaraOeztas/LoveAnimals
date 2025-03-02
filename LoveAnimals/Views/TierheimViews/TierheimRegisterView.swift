//
//  TierheimRegisterView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 11.02.25.
//

import SwiftUI

struct TierheimRegisterView: View {
    @StateObject private var viewModel = TierheimAuthViewModel()
    @State private var tierheimName: String = ""
    @State private var straße: String = ""
    @State private var plz: String = ""
    @State private var ort: String = ""
    @State private var email: String = ""
    @State private var homepage: String = ""
    @State private var akzeptiertBarzahlung: Bool = false
    @State private var akzeptiertUeberweisung: Bool = false
    @State private var empfaengerName: String = ""
    @State private var iban: String = ""
    @State private var bic: String = ""
    @State private var nimmtSpendenAn: Bool = false
    @State private var spendenIban: String = ""
    @State private var spendenBic: String = ""
    @State private var passwort: String = ""
    
    @State private var isEmailValid: Bool? = nil
    @State private var showFormError: Bool = false
    @State private var showEmailExistsError: Bool = false
    @State private var confirmPassword = ""
    @State private var isPasswordValid: Bool = false
    @State private var passwortMatch: Bool = true
    @State private var showPassword: Bool = false
    @State private var showPasswordCriteria: Bool = false
    @FocusState private var isPasswordFieldFocused: Bool
    @FocusState private var isConfirmPasswordFieldFocused: Bool
    @State private var navigateToLogin: Bool = false
    @State private var agbAccepted = false
    @State private var isLoading: Bool = false
    @State private var navigateToHome: Bool = false
    
    
    private var isFormValid: Bool {
        !tierheimName.isEmpty
        && !straße.isEmpty
        && !plz.isEmpty
        && !ort.isEmpty
        && !email.isEmpty
        && !passwort.isEmpty
        && !confirmPassword.isEmpty
        && isPasswordValid
        && passwortMatch
        && agbAccepted
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                TextField("Tierheim-Name", text: $tierheimName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                    .keyboardType(.asciiCapable)
                
                TextField("Homepage (optional)", text: $homepage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                    .keyboardType(.asciiCapable)
                
                TextField("Straße", text: $straße)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                    .keyboardType(.asciiCapable)
                
                HStack {
                    TextField("PLZ", text: $plz)
                        .frame(width: 100)
                    TextField("Ort", text: $ort)
                        .textInputAutocapitalization(.words)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .keyboardType(.asciiCapableNumberPad)
                .padding(.horizontal)
                
                VStack {
                    TextField("E-Mail", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .onChange(of: email) { _, _ in
                            showFormError = false
                            showEmailExistsError = false
                            isEmailValid = nil
                        }
                    
                    if showFormError {
                        Text("Bitte gib eine gültige E-Mail-Adresse ein.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }
                    
                    if showEmailExistsError {
                        Text("Diese E-Mail-Adresse wird bereits verwendet.")
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }
                }
                
                Group {
                    if showPassword {
                        TextField("Passwort", text: $passwort)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isPasswordFieldFocused)
                            .onChange(of: passwort) { _, newValue in
                                validatePassword()
                            }
                    } else {
                        SecureField("Passwort", text: $passwort)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isConfirmPasswordFieldFocused)
                            .textContentType(.oneTimeCode)
                            .onChange(of: passwort) { _, newValue in
                                validatePassword()
                            }
                    }
                    
                    if showPassword {
                        TextField("Passwort bestätigen", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isConfirmPasswordFieldFocused)
                            .onChange(of: confirmPassword) { _, newValue in
                                validatePassword()
                            }
                    } else {
                        SecureField("Passwort bestätigen", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isConfirmPasswordFieldFocused)
                            .textContentType(.oneTimeCode)
                            .onChange(of: confirmPassword) { _, newValue in
                                validatePassword()
                            }
                    }
                }
                .padding(.horizontal)
                
                if isPasswordFieldFocused || isConfirmPasswordFieldFocused {
                    VStack(alignment: .leading, spacing: 5) {
                        PasswortKriterien(text: "Mindestens 6 Zeichen", isValid: passwort.count >= 6)
                        PasswortKriterien(text: "Mindestens ein Großbuchstabe", isValid: passwort.rangeOfCharacter(from: .uppercaseLetters) != nil)
                        PasswortKriterien(text: "Mindestens ein Kleinbuchstabe", isValid: passwort.rangeOfCharacter(from: .lowercaseLetters) != nil)
                        PasswortKriterien(text: "Mindestens eine Zahl", isValid: passwort.rangeOfCharacter(from: .decimalDigits) != nil)
                    }
                    .font(.footnote)
                    .padding(.horizontal)
                }
                
                if !passwortMatch && !confirmPassword.isEmpty {
                    Text("Die Passwörter stimmen nicht überein. Bitte überprüfen Sie es erneut.")
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                HStack {
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "checkmark.square" : "square")
                            .foregroundStyle(showPassword ? .black : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Text("Passwort anzeigen")
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.horizontal)
                
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welche Zahlungsarten werden akzeptiert?")
                    HStack {
                        Toggle("Barzahlung", isOn: $akzeptiertBarzahlung)
                            .toggleStyle(CheckboxToggleStyle())
                        Spacer()
                        Toggle("Überweisung", isOn: $akzeptiertUeberweisung)
                            .toggleStyle(CheckboxToggleStyle())
                    }
                        if akzeptiertUeberweisung {
                            TextField("Empfängername", text: $empfaengerName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .keyboardType(.asciiCapable)
                            TextField("IBAN", text: $iban)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .keyboardType(.asciiCapable)
                            TextField("BIC", text: $bic)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .keyboardType(.asciiCapable)
                        }
            
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Toggle(isOn: $nimmtSpendenAn) {
                            Text("Ja wir möchten an Spenden teilnehmen.")
                                .font(.caption)
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }
                    
                    if nimmtSpendenAn {
                        if !akzeptiertUeberweisung {
                            TextField("Empfängername", text: $empfaengerName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .keyboardType(.asciiCapable)
                            TextField("IBAN", text: $spendenIban)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .keyboardType(.asciiCapable)
                            TextField("BIC", text: $spendenBic)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.words)
                                .keyboardType(.asciiCapable)
                        } else if akzeptiertUeberweisung && !empfaengerName.isEmpty && !iban.isEmpty && !bic.isEmpty {
                            Text("Die Kontodaten für Spenden wurden übernommen.")
                                .font(.headline)
                        } else {
                            Text("Bitte tragen Sie Ihre Kontodaten ein.")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                HStack(spacing: 0) {
                    Button(action: {
                        agbAccepted.toggle()
                    }) {
                        Image(systemName: agbAccepted ? "checkmark.square.fill" : "square")
                            .foregroundStyle(agbAccepted ? .blue : .gray)
                    }
                    .padding(.trailing, 10)
                    Text("Hiermit akzeptiere ich die ")
                        .font(.caption)
                    
                    NavigationLink("AGB", destination: AGBView())
                        .foregroundStyle(.blue)
                        .underline()
                        .font(.caption)
                    
                    Text(" und ")
                        .font(.caption)
                    
                    NavigationLink("Datenschutzerklärung", destination: DatenschutzView())
                        .foregroundStyle(.blue)
                        .underline()
                        .font(.caption)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
            
                VStack {
                    Button(action: {
                        Task {
                            isLoading = true
                            viewModel.checkIfEmailExistsInFirestore(email: email) { exists in
                                DispatchQueue.main.async {
                                    if exists {
                                        showEmailExistsError = true
                                        isLoading = false
                                    } else {
                                        Task {
                                            guard let isValid = try? await EmailValidationRepository.shared.validateEmailWithAPI(email: email), isValid else {
                                                DispatchQueue.main.async {
                                                    isLoading = false
                                                    isEmailValid = false
                                                    showFormError = true
                                                    
                                                }
                                                return
                                            }
                                            DispatchQueue.main.async {
                                                isLoading = false
                                                isEmailValid = true
                                                showFormError = false
                                                showEmailExistsError = false
                                                
                                                Task {
                                                    await viewModel.registerTierheim(
                                                        tierheimName: tierheimName,
                                                        straße: straße,
                                                        plz: plz,
                                                        ort: ort,
                                                        email: email,
                                                        homepage: homepage,
                                                        nimmtSpendenAn: nimmtSpendenAn,
                                                        passwort: passwort,
                                                        signedUpOn: Date()
                                                    )
                                                }
                                                navigateToHome = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Registrieren")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.customLightBrown)
                                .cornerRadius(10)
                                .disabled(!isFormValid)
                                .opacity(isFormValid ? 1.0 : 0.5)
                        }
                    }
                    .navigationDestination(isPresented: $navigateToHome) {
                        TierheimHomeView2()
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
    
    private func validatePassword() {
        let isLongEnough = passwort.count >= 6
        let hasUpperCase = passwort.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowerCase = passwort.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumber = passwort.rangeOfCharacter(from: .decimalDigits) != nil
        
        passwortMatch = !passwort.isEmpty && !confirmPassword.isEmpty && passwort == confirmPassword
        isPasswordValid = isLongEnough && hasUpperCase && hasLowerCase && hasNumber && passwortMatch
        showPasswordCriteria = !isPasswordValid
    }
}

#Preview {
    TierheimRegisterView()
        .environmentObject(UserAuthViewModel())
}
