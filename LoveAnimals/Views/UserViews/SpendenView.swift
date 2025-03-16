//
//  SpendenView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.03.25.
//

import SwiftUI

struct SpendenView: View {
    @State private var spendenBetrag: String = ""
    @State private var selectedPaymentMethod: String = "Kreditkarte"
    @State private var showConfirmation = false
    
    let paymentMethods = ["Kreditkarte", "PayPal", "Apple Pay"]

    var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.red)
                
                Text("Unterstütze Tierheime!")
                    .font(.title)
                    .bold()
                
                Text("Jede Spende hilft, Tieren ein besseres Leben zu ermöglichen.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Spendenbetrag (€)")
                        .font(.headline)
                    
                    TextField("z. B. 10.00", text: $spendenBetrag)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.top, 50)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Zahlungsmethode wählen")
                        .font(.headline)

                    Picker("Zahlungsmethode", selection: $selectedPaymentMethod) {
                        ForEach(paymentMethods, id: \.self) { method in
                            Text(method)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.top, 20)
                
                Button(action: processDonation) {
                    Text("Jetzt spenden")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .disabled(!isDonationValid()).opacity(isDonationValid() ? 1 : 0.6)
                .padding(.horizontal)
                .padding(.top, 40)

            }
            .padding()
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("Danke für deine Spende!"),
                    message: Text("Deine Unterstützung hilft Tieren in Not."),
                    dismissButton: .default(Text("OK"))
                )
            }
        
    }
    
    private func processDonation() {
        guard let amount = Double(spendenBetrag), amount > 0 else {
            return
        }
        showConfirmation = true
        spendenBetrag = ""
    }
    
    private func isDonationValid() -> Bool {
        guard let amount = Double(spendenBetrag), amount > 0 else {
            return false
        }
        return true
    }
}


#Preview {
    SpendenView()
}
