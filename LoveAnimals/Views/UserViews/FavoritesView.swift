//
//  FavoritesView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: AnimalsViewModel

    var body: some View {
        NavigationStack {
            if viewModel.favoriten.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.gray)

                    Text("Du hast noch keine Favoriten.")
                        .font(.title3)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Favoriten")
            } else {
                List(viewModel.favoriten) { animal in
                    NavigationLink(destination: UserAnimalDetailView(animal: animal)) {
                        HStack {
                            if let firstImage = animal.bilder.first, let url = URL(string: firstImage) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundStyle(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }

                            VStack(alignment: .leading) {
                                Text(animal.name)
                                    .font(.headline)
                                Text(animal.rasse)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.removeFavorite(animalID: animal.id ?? "")
                            }
                        } label: {
                            Label("Entfernen", systemImage: "trash")
                        }
                    }
                }
                .navigationTitle("Favoriten")
            }
        }
        .task {
            await viewModel.loadFavorites()
        }
    }
}


#Preview {
    FavoritesView()
        .environmentObject(AnimalsViewModel())
}
