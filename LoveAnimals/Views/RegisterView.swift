//
//  RegisterView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Registrieren")
                .font(.largeTitle)
                .fontWeight(.bold)
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
                authViewModel.register(email: email, password: password) { success in
                    if success {
                        print("Registrierung erfolgreich!")
                    }
                }
            }) {
                Text("Registrieren")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
            NavigationLink("Bereits ein Konto? Jetzt anmelden!", destination: LoginView())
                .padding()
        }
        .padding()
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
