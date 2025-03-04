//
//  AnimalsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

import SwiftUI

struct AnimalsView: View {
    let animal: Animal
    let userCoordinates: (latitude: Double, longitude: Double)?

    var body: some View {
        VStack {
            if !animal.imageURL.isEmpty {
                AsyncImage(url: URL(string: animal.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    case .failure:
                        Image("Kein-Foto")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    @unknown default:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                }
            } else {
                Image("Kein-Foto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            }

            Text(animal.tierheimName)
                .font(.footnote)
                .fontWeight(.semibold)

            if let userCoordinates {
                let distance = DistanceCalculator.calculateDistance(
                    from: userCoordinates,
                    toPLZ: animal.tierheimPLZ
                )
                Text("\(distance, specifier: "%.1f") km entfernt")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                Text("Entfernung lädt...")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    AnimalsView(animal: Animal(name: "Bella", imageURL: "https://example.com/bella.jpg", tierheimName: "Tierheim Köln", tierheimPLZ: "50825"), userCoordinates: (latitude: 50.9375, longitude: 6.9603))
}
