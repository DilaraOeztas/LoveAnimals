//
//  RegisterView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.02.25.
//

import SwiftUI

struct RoleSelectionView: View {
    @State private var isUser = false
    @State private var isTierheim = false

    var body: some View {
        VStack {
            Image("AppIcon3")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.top, 16)
            
            Spacer()
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
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $isUser) {
                    UserRegisterView()
                }
                
                Text("ODER")
                
                Button(action: {
                    isTierheim = true
                }) {
                    Text("Als Tierheim fortfahren")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.customLightBrown)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $isTierheim) {
                    TierheimRegisterView()
                }
            }
            Spacer().frame(height: 300)
        }
    }
}



#Preview {
    RoleSelectionView()
}
