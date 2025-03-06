//
//  FormularView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

import SwiftUI

struct FormularView: View {
    @ObservedObject var viewModel: TierEinstellenViewModel
    
    var body: some View {
        VStack {
            TierOptionView(title: "Tierart", value: viewModel.ausgewaehlteTierart) {
                viewModel.showTierartSheet = true
            }
            .sheet(isPresented: $viewModel.showTierartSheet) {
                TierartSheet(ausgewaehlteTierart: $viewModel.ausgewaehlteTierart, showTierartSheet: $viewModel.showTierartSheet)
            }
            
            TierOptionView(title: "Rasse", value: viewModel.ausgewaehlteRasse) {
                if let tierart = Tierart(rawValue: viewModel.ausgewaehlteTierart) {
                    viewModel.aktuelleRassen = tierart.rassen()
                }
                viewModel.showRassenSheet = true
            }
            .sheet(isPresented: $viewModel.showRassenSheet) {
                RassenSheet(rassen: viewModel.aktuelleRassen, ausgewaehlteRasse: $viewModel.ausgewaehlteRasse, showRasseSheet: $viewModel.showRassenSheet)
            }
            
            TierOptionView(title: "Alter", value: viewModel.ausgewaehltesAlter) {
                viewModel.showAlterSheet = true
            }
            .sheet(isPresented: $viewModel.showAlterSheet) {
                AlterSheet(ausgewaehlteAlter: $viewModel.ausgewaehltesAlter, showAlterSheet: $viewModel.showAlterSheet)
            }
            
            TierOptionView(title: "Größe", value: viewModel.ausgewaehlteGroesse) {
                viewModel.showGroesseSheet = true
            }
            .sheet(isPresented: $viewModel.showGroesseSheet) {
                GroessenSheet(ausgewaehlteGroesse: $viewModel.ausgewaehlteGroesse, showGroessenSheet: $viewModel.showGroesseSheet)
            }
            
            TierOptionView(title: "Geschlecht", value: viewModel.ausgewaehltesGeschlecht) {
                viewModel.showGeschlechtSheet = true
            }
            .sheet(isPresented: $viewModel.showGeschlechtSheet) {
                GeschlechtSheet(ausgewaehltesGeschlecht: $viewModel.ausgewaehltesGeschlecht, showSheet: $viewModel.showGeschlechtSheet)
            }
            
            TierOptionView(title: "Farbe", value: viewModel.ausgewaehlteFarbe) {
                viewModel.showFarbenSheet = true
            }
            .sheet(isPresented: $viewModel.showFarbenSheet) {
                FarbenSheet(ausgewaehlteFarbe: $viewModel.ausgewaehlteFarbe, showFarbenSheet: $viewModel.showFarbenSheet)
            }
            
            TierOptionView(title: "Gesundheit", value: viewModel.ausgewaehlteGesundheit) {
                viewModel.showGesundheitSheet = true
            }
            .sheet(isPresented: $viewModel.showGesundheitSheet) {
                Gesundheitszustand(ausgewaehlteGesundheit: $viewModel.ausgewaehlteGesundheit, showGesundheitSheet: $viewModel.showGesundheitSheet)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Name des Tieres")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                TextField("z. B. Bella", text: $viewModel.tierName)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                    )
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Beschreibung")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                TextEditor(text: $viewModel.tierBeschreibung)
                    .padding(.horizontal, 5)
                    .frame(minHeight: 120, maxHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                    )
                
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Schutzgebühr (€)")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                TextField("z. B. 150", text: $viewModel.schutzgebuehr)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                    )
                    .keyboardType(.numberPad)
            }
            .padding(.top, 10)
            
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}
