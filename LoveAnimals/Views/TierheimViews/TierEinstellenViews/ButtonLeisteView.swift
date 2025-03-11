//
//  ButtonLeisteView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

import SwiftUI

struct ButtonLeisteView: View {
    @ObservedObject var viewModel: TierEinstellenViewModel
    @EnvironmentObject var animalsViewModel: AnimalsViewModel
    @Binding var selectedTab: Int
    
    @AppStorage("showPostUploadToast") var showPostUploadToast = false

    
    var body: some View {
        VStack(alignment: .center) {
            Button("Tier einstellen") {
                selectedTab = 0
                showPostUploadToast = true
                Task {
                    if !viewModel.ausgewaehlteTierart.isEmpty || !viewModel.ausgewaehlteRasse.isEmpty {
                        await viewModel.speichereBenutzerdefinierteTierart(neueTierart: viewModel.ausgewaehlteTierart, neueRasse: viewModel.ausgewaehlteRasse)
                    }
                    if !viewModel.ausgewaehlteFarbe.isEmpty {
                        await viewModel.speichereBenutzerdefinierteFarben(farbe: viewModel.ausgewaehlteFarbe)
                    }
                    await viewModel.uploadAllImagesAndSave()
                    await animalsViewModel.ladeAlleTiere()
                    await viewModel.ladeBenutzerdefinierteFarben()
                }
            }
            .padding()
            .background(Color.customBrown)
            .foregroundStyle(.white)
            .cornerRadius(8)
        }
        .padding(.bottom, 30)
    }
}

