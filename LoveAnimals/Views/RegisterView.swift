//
//  RegisterView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI

struct RegisterView: View {
    @State private var isUser = false
    @State private var isTierheim = false

    var body: some View {
            VStack(spacing: 20) {

                Text("Bitte auswählen:")
                    .font(.headline)

                Button(action: {
                    isUser = true
                }) {
                    Text("Ich möchte ein Tier adoptieren")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.customBrown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $isUser) {
                    UserRegisterView()
                }

                Button(action: {
                    isTierheim = true
                }) {
                    Text("Ich bin ein Tierheim")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.customLightBrown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $isTierheim) {
                    TierheimRegisterView()
                }
            }
    }
}



#Preview {
    RegisterView()
}
