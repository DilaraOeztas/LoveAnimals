//
//  AnimalsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

import SwiftUI
import FirebaseFirestore

struct AnimalsView: View {
    let animal: Animal

    @State private var tierheimPLZ = ""

    var body: some View {
        VStack(alignment: .center) {
            if let firstImageURL = animal.bilder.first, let url = URL(string: firstImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 90, height: 80)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 80)
                            .clipShape(Circle())
                    case .failure:
                        Image("Kein-Foto")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 80)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("Kein-Foto")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 80)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(animal.name)
                    .font(.headline)
                
            }
        }
    }
}

