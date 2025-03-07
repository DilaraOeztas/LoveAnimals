//
//  HeaderView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 07.03.25.
//

import SwiftUI

struct HeaderView: View {
    let profileImage: UIImage?
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(uiImage: profileImage ?? UIImage(named: "Kein-Foto")!)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            TextField("Suche...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                
            }) {
                Image(systemName: "bell")
                    .font(.title2)
            }
        }
        .padding()
    }
}
