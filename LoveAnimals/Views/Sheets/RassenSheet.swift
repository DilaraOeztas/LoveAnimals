//
//  RassenSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct RassenSheet: View {
    let rassen: [String]
    @Binding var ausgewaehlteRasse: String
    @Binding var showRasseSheet: Bool
    
    var body: some View {
        NavigationStack {
            List(rassen, id: \.self) { rasse in
                HStack {
                    Text(rasse)
                        .foregroundStyle(.black)
                    Spacer()
                    if rasse == ausgewaehlteRasse {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "circle")
                            
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    ausgewaehlteRasse = rasse
                    showRasseSheet = false
                }
            }
            .navigationBarTitle("Rasse wählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showRasseSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    RassenSheet(rassen: ["Mischling", "Schäferhund"], ausgewaehlteRasse: .constant("Mischling"), showRasseSheet: .constant(true))
}
