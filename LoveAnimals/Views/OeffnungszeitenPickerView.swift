//
//  OeffnungszeitenPickerView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 19.02.25.
//

import SwiftUI

struct OeffnungszeitenPickerView: View {
    @ObservedObject var viewModel: TierheimAuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 15) {
            Text("\(viewModel.selectedDay ?? "") Öffnungszeiten")
                .font(.headline)
                .bold()
            
            DatePicker("Von", selection: Binding(
                get: { viewModel.öffnungszeiten[viewModel.selectedDay ?? ""]?.von ?? Date() },
                set: { viewModel.öffnungszeiten[viewModel.selectedDay ?? ""] = Öffnungszeit(von: $0, bis: viewModel.öffnungszeiten[viewModel.selectedDay ?? ""]?.bis ?? Date()) }
            ), displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())

            DatePicker("Bis", selection: Binding(
                get: { viewModel.öffnungszeiten[viewModel.selectedDay ?? ""]?.bis ?? Date() },
                set: { viewModel.öffnungszeiten[viewModel.selectedDay ?? ""] = Öffnungszeit(von: viewModel.öffnungszeiten[viewModel.selectedDay ?? ""]?.von ?? Date(), bis: $0) }
            ), displayedComponents: .hourAndMinute)
            .datePickerStyle(WheelDatePickerStyle())

            Button("Speichern") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 10)
        }
        .padding()
    }
}

#Preview {
    OeffnungszeitenPickerView(viewModel: TierheimAuthViewModel())
}
