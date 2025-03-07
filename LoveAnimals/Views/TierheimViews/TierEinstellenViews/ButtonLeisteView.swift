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
                Task {
                    selectedTab = 0
                    showPostUploadToast = true

                    Task {
                        await viewModel.uploadAllImagesAndSave()
                        await animalsViewModel.ladeAlleTiere()
                    }
                }
            }
            .padding()
            .background(Color.customBrown)
            .foregroundStyle(.white)
            .cornerRadius(8)
        }
    }
}

