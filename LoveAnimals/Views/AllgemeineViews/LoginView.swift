//
//  LoginView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: UserAuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var remeberMe: Bool = false
    @State private var ispasswordVisible = false
    @State private var navigateToRoleSelection: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        TextField("E-Mail", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                        
                        ZStack(alignment: .trailing) {
                            if ispasswordVisible {
                                TextField("Passwort", text: $password)
                                
                            } else {
                                SecureField("Passwort", text: $password)
                                
                            }
                            Button(action: {
                                ispasswordVisible.toggle()
                            }) {
                                Image(systemName: ispasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundStyle(.gray).padding(.trailing, 10)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                        
                        
                        Text("Passwort vergessen?")
                            .underline()
                            .font(.caption)
                        Toggle(isOn: $remeberMe) {
                            Text("Angemeldet bleiben")
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .padding(.top, 10)
                        .onChange(of: remeberMe) { _, newValue in
                            authViewModel.setRememberMe(newValue)
                        }
                    }
                    .padding(.horizontal)
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding(.top, 5)
                    }
                }
                
                VStack {
                    Button(action: {
                        Task {
                            await authViewModel.login(email: email, password: password)
                        }
                    }) {
                        Text("Anmelden")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.customLightBrown)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 40)
                
                Button(action: {
                    navigateToRoleSelection = true
                }) {
                    Text("Noch kein Account? Jetzt registrieren!")
                        .foregroundStyle(.blue)
                        .underline()
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            
            .onAppear {
                let savedData = authViewModel.loadLoginData()
                DispatchQueue.main.async {
                    email = savedData.email
                    password = savedData.password
                    remeberMe = savedData.rememberMe
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            )
            .padding(.top, 10)
            .navigationDestination(isPresented: $navigateToRoleSelection) {
                RoleSelectionView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserAuthViewModel())
}
