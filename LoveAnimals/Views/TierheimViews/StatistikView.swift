//
//  StatistikView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 10.03.25.
//

import SwiftUI
import Charts

struct StatistikView: View {
    @State private var selectedCategory = "Aufrufe"
    
    let categories = ["Aufrufe", "Vermittlungen", "Favoriten"]
    
    let tiereStats: [TierStatistik] = [
        TierStatistik(name: "Bella", aufrufe: 120, vermittlungen: 5, favoriten: 35),
        TierStatistik(name: "Rocky", aufrufe: 85, vermittlungen: 3, favoriten: 20),
        TierStatistik(name: "Luna", aufrufe: 150, vermittlungen: 7, favoriten: 50),
        TierStatistik(name: "Max", aufrufe: 60, vermittlungen: 2, favoriten: 18),
        TierStatistik(name: "Milo", aufrufe: 90, vermittlungen: 4, favoriten: 25)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Kategorie wählen", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Chart {
                    ForEach(tiereStats) { tier in
                        BarMark(
                            x: .value("Anzahl", selectedCategory == "Aufrufe" ? tier.aufrufe : selectedCategory == "Vermittlungen" ? tier.vermittlungen : tier.favoriten),
                            y: .value("Tier", tier.name)
                        )
                        .foregroundStyle(selectedCategory == "Aufrufe" ? .blue : selectedCategory == "Vermittlungen" ? .green : .purple)
                    }
                }
                .frame(height: 300)
                .padding()
                
                List {
                    ForEach(tiereStats) { tier in
                        HStack {
                            Text(tier.name)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(selectedCategory == "Aufrufe" ? tier.aufrufe : selectedCategory == "Vermittlungen" ? tier.vermittlungen : tier.favoriten)")
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Statistik")
        }
    }
}




#Preview {
    StatistikView()
}
