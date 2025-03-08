//
//  AlterSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct AlterSheet: View {
    @Binding var ausgewaehlteAlter: String
    @Binding var showAlterSheet: Bool
    
    @State private var geburtsdatum: Date? = nil
    @State private var tempGeburtsdatum: Date = Date()
    @State private var showDatePicker = false
    @State private var sheetSize: PresentationDetent = .medium
    
    let alterKategorien = ["Jung", "Erwachsen", "Senior"]
    
    func berechnetesAlter(fuer datum: Date) -> String {
        let alter = Calendar.current.dateComponents([.year], from: datum, to: Date()).year ?? 0
        
        if alter < 1 {
            return "Jung"
        } else if alter < 6 {
            return "Erwachsen"
        } else {
            return "Senior"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        HStack {
                            Text("Geburtsdatum")
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            if let datum = geburtsdatum {
                                Text(datum.formatted(date: .abbreviated, time: .omitted))
                                    .foregroundStyle(.blue)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .onTapGesture {
                                        geburtsdatum = nil
                                        tempGeburtsdatum = Date()
                                        ausgewaehlteAlter = ""
                                    }
                            } else {
                                Text("Nicht angegeben")
                                    .foregroundStyle(.gray)
                                
                                Image(systemName: "circle")
                                    .onTapGesture {
                                        geburtsdatum = nil
                                        tempGeburtsdatum = Date()
                                        ausgewaehlteAlter = ""
                                    }
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showDatePicker = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                sheetSize = .large
                            }
                            tempGeburtsdatum = geburtsdatum ?? Date()
                        }
                        
                        if showDatePicker {
                            VStack(alignment: .trailing) {
                                DatePicker(
                                    "",
                                    selection: $tempGeburtsdatum,
                                    in: Calendar.current.date(byAdding: .year, value: -30, to: Date())!...Date(),
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.graphical)
                                
                                Button("Fertig") {
                                    geburtsdatum = tempGeburtsdatum
                                    ausgewaehlteAlter = berechnetesAlter(fuer: tempGeburtsdatum)
                                    showDatePicker = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        sheetSize = .medium
                                    }
                                }
                                .font(.headline)
                                
                            }
                        }
                    }
                    
                    ForEach(alterKategorien, id: \.self) { alter in
                        HStack {
                            Text(alter)
                                .foregroundStyle(.black)
                            Spacer()
                            if alter == ausgewaehlteAlter {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            ausgewaehlteAlter = alter
                            geburtsdatum = nil
                            showDatePicker = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                sheetSize = .medium
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alter auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        showAlterSheet = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") {
                        showAlterSheet = false
                    }
                    .font(.headline)
                }
            }
            .presentationDetents([.medium, .large], selection: $sheetSize)
        }
    }
}

#Preview {
    AlterSheet(ausgewaehlteAlter: .constant(""), showAlterSheet: .constant(true))
}






