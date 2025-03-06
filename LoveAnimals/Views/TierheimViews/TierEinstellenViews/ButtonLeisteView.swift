//
//  ButtonLeisteView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

import SwiftUI

struct ButtonLeisteView: View {
    @ObservedObject var viewModel: TierEinstellenViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(alignment: .center) {
            Button("Tier einstellen") {
                Task {
                    await viewModel.uploadAllImagesAndSave()
                    selectedTab = 0
                }
            }
            .padding()
            .background(Color.customBrown)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
