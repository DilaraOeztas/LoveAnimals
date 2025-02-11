//
//  LoginView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = UserDefaults.standard.string(forKey: "savedEmail") ?? ""
    @State private var password = UserDefaults.standard.string(forKey: "savedPassword") ?? ""
    @State private var remeberMe = UserDefaults.standard.bool(forKey: "remeberMe")
    @State private var ispasswordVisible = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                
                VStack {
                    TextField("E-Mail", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
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
                                .foregroundStyle(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    Toggle(isOn: $remeberMe) {
                        Text("Daten merken")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
            }
            VStack {
                Button(action: {
                    authViewModel.login(email: email, password: password) { success in
                        if success {
                            print("Login erfolgreich!")
                            
                            if remeberMe {
                                UserDefaults.standard.set(email, forKey: "savedEmail")
                                UserDefaults.standard.set(password, forKey: "savedPassword")
                                UserDefaults.standard.set(true, forKey: "remeberMe")
                            } else {
                                UserDefaults.standard.removeObject(forKey: "savedEmail")
                                UserDefaults.standard.removeObject(forKey: "savedPassword")
                                UserDefaults.standard.set(false, forKey: "remeberMe")
                            }
                        }
                    }
                }) {
                    Text("Anmelden")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.customLightBrown)
                        .cornerRadius(10)
                }
            }
            .padding(.top, 20)
            
            NavigationLink("Noch kein Account? Jetzt registrieren!", destination: RegisterView())
                .padding(.top, 20)
        }
        .padding(.bottom, 100)
    }
    
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
