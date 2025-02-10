//
//  LoginView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("AppLogo4")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .padding()
            
            TextField("E-Mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Passwort", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                authViewModel.login(email: email, password: password) { success in
                    if success {
                        print("Login erfolgreich!")
                    }
                }
            }) {
                Text("Anmelden")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            NavigationLink("Noch kein Account? Jetzt registrieren!", destination: RegisterView())
                .padding()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
