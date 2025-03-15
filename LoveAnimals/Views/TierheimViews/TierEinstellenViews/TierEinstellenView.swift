//
//  TierEinstellenView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI
import PhotosUI

struct TierEinstellenView: View {
    @StateObject private var viewModel = TierEinstellenViewModel()
    @EnvironmentObject var animalsViewModel: AnimalsViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var navigateBack: Bool
    @Binding var selectedTab: Int
    @State private var showAbbrechenAlert = false
    @State private var showImageSourceDialog = false
    @State private var isCameraSelected = false
    @State private var showGalleryPicker = false
    
    @State var animal: Animal?
    
    var body: some View {
        ScrollView {
            VStack {
                BilderView(viewModel: viewModel,
                           showImageSourceDialog: $showImageSourceDialog,
                           isCameraSelected: $isCameraSelected,
                           showGalleryPicker: $showGalleryPicker)
                
                FormularView(viewModel: viewModel)
                
                ButtonLeisteView(viewModel: viewModel, selectedTab: $selectedTab, animal: $animal)
            }
        }
        .navigationTitle(animal != nil ? "Tier bearbeiten" : "Tier einstellen")
        .onAppear {
            if let animal = animal {
                viewModel.ladeTierDaten(animal)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Abbrechen") {
                    showAbbrechenAlert = true
                }
            }
        }
        .alert("Hinweis", isPresented: $showAbbrechenAlert) {
            Button("Abbrechen", role: .destructive) {
                selectedTab = 0
                viewModel.resetForm()
            }
            Button("Fortfahren", role: .cancel) { }
        } message: {
            Text("Wenn du abbrichst, gehen alle Eingaben verloren. Möchtest du wirklich abbrechen?")
        }
        
        if let animal = animal {
            Button(role: .destructive) {
                animalsViewModel.loescheTier(animal) { success in
                if success {
                    navigateBack = true
                        dismiss()
                    }
                }
            } label: {
                Text("Tier löschen")
                    .bold()
                    .padding()
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
            .padding(.bottom)
        }
    }
}






//#Preview {
//    TierEinstellenView(selectedTab: .constant(1))
//        .environmentObject(TierEinstellenViewModel())
//}
