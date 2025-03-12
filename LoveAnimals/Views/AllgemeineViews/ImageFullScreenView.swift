//
//  SwiftUIView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.03.25.
//

import SwiftUI

struct ImageFullScreenView: View {
    let images: [String]
    @State private var currentIndex: Int
    let onClose: () -> Void

    init(images: [String], selectedIndex: Int, onClose: @escaping () -> Void) {
        self.images = images
        self._currentIndex = State(initialValue: selectedIndex)
        self.onClose = onClose
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    if let url = URL(string: images[index]) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .tag(index)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.gray)
                                    .tag(index)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            VStack {
                HStack {
                    Spacer()
                    Button(action: { onClose() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                Spacer()

                HStack {
                    ForEach(images.indices, id: \.self) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(currentIndex == index ? .white : .gray.opacity(0.8))
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

