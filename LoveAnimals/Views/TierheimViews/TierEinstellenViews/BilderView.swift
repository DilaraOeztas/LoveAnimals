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
                Image(uiImage: firstImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "plus.circle")
                            .font(.system(size: 60))
                            .foregroundStyle(.gray)
                    )
                    .onTapGesture {
                        showImageSourceDialog = true
                    }
            }
            
            if viewModel.selectedImages.count >= 1 {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.selectedImages.dropFirst(), id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 80)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
                
                Button("Weitere Bilder hinzufügen") {
                    showImageSourceDialog = true
                }
                .padding()
                .background(Color.customBrown)
                .foregroundColor(.white)
                .cornerRadius(8)
                
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
}

