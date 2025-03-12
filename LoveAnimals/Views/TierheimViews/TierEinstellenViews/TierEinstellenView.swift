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
    @Binding var selectedTab: Int
    @State private var showAbbrechenAlert = false
    @State private var showImageSourceDialog = false
    @State private var isCameraSelected = false
    @State private var showGalleryPicker = false
    
    var body: some View {
        ScrollView {
            VStack {
                BilderView(viewModel: viewModel,
                           showImageSourceDialog: $showImageSourceDialog,
                           isCameraSelected: $isCameraSelected,
                           showGalleryPicker: $showGalleryPicker)
                
                FormularView(viewModel: viewModel)
                
                ButtonLeisteView(viewModel: viewModel, selectedTab: $selectedTab)
            }
        }
        .navigationTitle("Tier einstellen")
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
    }
}






#Preview {
    TierEinstellenView(selectedTab: .constant(1))
        .environmentObject(TierEinstellenViewModel())
}
