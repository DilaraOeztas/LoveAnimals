//
//  TierheimRegisterView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 11.02.25.
//

import SwiftUI

struct TierheimRegisterView: View {
    @StateObject private var viewModel = TierheimAuthViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Registrierung")
                        .font(.title)
                        .bold()

                    TextField("Name", text: $viewModel.tierheimName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Straße", text: $viewModel.straße)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        HStack {
                            TextField("PLZ", text: $viewModel.plz)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                            
                            TextField("Ort", text: $viewModel.ort)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    
                    
                    TextField("Telefonnummer", text: $viewModel.telefonnummer)
                        .keyboardType(.phonePad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Homepage (optional)", text: $viewModel.homepage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("E-Mail", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    SecureField("Passwort", text: $viewModel.passwort)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    SecureField("Passwort bestätigen", text: $viewModel.confirmPasswort)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Welche Zahlunsarten akzeptierst du?")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    HStack {
                        Toggle("Barzahlung", isOn: $viewModel.akzeptiertBarzahlung)
                            .toggleStyle(CheckboxToggleStyle())
                        Spacer()
                        Toggle("Überweisung", isOn: $viewModel.akzeptiertÜberweisung)
                            .toggleStyle(CheckboxToggleStyle())
                    }
                    .padding(.vertical, 5)

                    if viewModel.akzeptiertÜberweisung {
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Empfängername", text: $viewModel.empfaengername)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("IBAN", text: $viewModel.iban)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("BIC", text: $viewModel.bic)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.top, 10)
                    }

                    Toggle("An Spenden teilnehmen", isOn: $viewModel.nimmtSpendenAn)

                    if viewModel.nimmtSpendenAn && !viewModel.akzeptiertÜberweisung {
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Empfängername", text: $viewModel.empfaengername)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Spenden-IBAN", text: $viewModel.spendenIban)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Spenden-BIC", text: $viewModel.spendenBic)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }

                    Text("Öffnungszeiten")
                        .font(.headline)
                        .bold()
                        .padding(.top, 10)

                    ForEach(["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"], id: \.self) { tag in
                        VStack {
                            HStack {
                                Text(tag)
                                    .font(.body)
                                
                                Spacer()
                                
                                if let zeiten = viewModel.öffnungszeiten[tag] {
                                    Text("\(formatTime(zeiten.von)) - \(formatTime(zeiten.bis))")
                                        .foregroundColor(.gray)
                                } else {
                                    Text("Geschlossen")
                                        .foregroundColor(.red)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.selectedDay = tag
                                viewModel.showTimePicker = true
                            }
                            .padding(.vertical, 5)
                            
                            Divider()
                        }
                    }
                    .sheet(isPresented: $viewModel.showTimePicker) {
                        OeffnungszeitenPickerView(viewModel: viewModel)
                    }

                    

                    Button(action: {
                        viewModel.registerTierheim()
                    }) {
                        Text(viewModel.isLoading ? "Registrieren..." : "Registrieren")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding()
            }
            .navigationDestination(isPresented: $viewModel.navigateToHome) {
                HomeView()
            }
        }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    TierheimRegisterView()
}
