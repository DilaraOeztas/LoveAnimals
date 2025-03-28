//
//  BilderView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

import SwiftUI
import PhotosUI

struct BilderView: View {
    @ObservedObject var viewModel: TierEinstellenViewModel
    @Binding var showImageSourceDialog: Bool
    @Binding var isCameraSelected: Bool
    @Binding var showGalleryPicker: Bool

    var body: some View {
        VStack {
            if let firstImage = viewModel.selectedImages.first {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: firstImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(8)

                    Button(action: {
                        removeImage(firstImage)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white, .red)
                    }
                    .offset(x: -10, y: 10)
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .cornerRadius(12)
                    .overlay(
                        VStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 60))
                                .foregroundStyle(.gray)
                            Text("Fotos hinzufügen")
                                .font(.headline)
                                .foregroundStyle(.gray)
                        }
                    )
                    .onTapGesture {
                        showImageSourceDialog = true
                    }
            }

            if viewModel.selectedImages.count >= 1 {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.selectedImages.dropFirst(), id: \.self) { image in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 80)
                                    .clipped()
                                    .cornerRadius(8)

                                Button(action: {
                                    removeImage(image)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.white, .red)
                                }
                                .offset(x: 1, y: -1)
                            }
                        }

                        Button(action: {
                            showImageSourceDialog = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 80)
                                Image(systemName: "plus")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .confirmationDialog("Foto auswählen", isPresented: $showImageSourceDialog) {
            Button("Kamera öffnen") { isCameraSelected = true }
            Button("Galerie öffnen") { showGalleryPicker = true }
        }
        .sheet(isPresented: $isCameraSelected) {
            ImagePickerView(sourceType: .camera) { image in
                viewModel.addImage(image)
            }
        }
        .photosPicker(isPresented: $showGalleryPicker, selection: $viewModel.imagePickerItems, maxSelectionCount: 6 - viewModel.selectedImages.count, matching: .images)
        .onChange(of: viewModel.imagePickerItems) { _, _ in
            viewModel.loadImagesFromPicker()
        }
    }

    private func removeImage(_ image: UIImage) {
        if let index = viewModel.selectedImages.firstIndex(of: image) {
            viewModel.selectedImages.remove(at: index)
        }
    }
}

