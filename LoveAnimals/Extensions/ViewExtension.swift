//
//  ViewExtension.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

//import SwiftUI
//
//extension View {
//    func tierSheets(
//        showTierartSheet: Binding<Bool>,
//        ausgewaehlteTierart: Binding<String>,
//        showRassenSheet: Binding<Bool>,
//        aktuelleRassen: [String],
//        ausgewaehlteRasse: Binding<String>,
//        showAlterSheet: Binding<Bool>,
//        ausgewaehltesAlter: Binding<String>,
//        showGroesseSheet: Binding<Bool>,
//        ausgewaehlteGroesse: Binding<String>,
//        showGeschlechtSheet: Binding<Bool>,
//        ausgewaehltesGeschlecht: Binding<String>,
//        showFarbenSheet: Binding<Bool>,
//        ausgewaehlteFarbe: Binding<String>,
//        showGesundheitSheet: Binding<Bool>,
//        ausgewaehlteGesundheit: Binding<String>
//    ) -> some View {
//        self
//            .sheet(isPresented: showTierartSheet) {
//                TierartSheet(ausgewaehlteTierart: ausgewaehlteTierart, showTierartSheet: showTierartSheet)
//            }
//            .sheet(isPresented: showRassenSheet) {
//                RassenSheet(rassen: aktuelleRassen, ausgewaehlteRasse: ausgewaehlteRasse, showRasseSheet: showRassenSheet)
//            }
//            .sheet(isPresented: showAlterSheet) {
//                AlterSheet(ausgewaehlteAlter: ausgewaehltesAlter, showAlterSheet: showAlterSheet)
//            }
//            .sheet(isPresented: showGroesseSheet) {
//                GroessenSheet(ausgewaehlteGroesse: ausgewaehlteGroesse, showGroessenSheet: showGroesseSheet)
//            }
//            .sheet(isPresented: showGeschlechtSheet) {
//                GeschlechtSheet(ausgewaehltesGeschlecht: ausgewaehltesGeschlecht, showSheet: showGeschlechtSheet)
//            }
//            .sheet(isPresented: showFarbenSheet) {
//                FarbenSheet(ausgewählteFarbe: ausgewaehlteFarbe, showFarbenSheet: showFarbenSheet)
//            }
//            .sheet(isPresented: showGesundheitSheet) {
//                Gesundheitszustand(ausgewaehlteGesundheit: ausgewaehlteGesundheit, showGesundheitSheet: showGesundheitSheet)
//            }
//    }
//}

