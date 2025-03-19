//
//  AlterSheet.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 04.03.25.
//

import SwiftUI

struct AlterSheet: View {
    @Binding var ausgewaehltesAlter: String
    @Binding var ausgewaehltesGeburtsdatum: Date?
    @Binding var showAlterSheet: Bool

    @State private var geburtsdatum: Date? = nil
    @State private var tempGeburtsdatum: Date? = nil
    @State private var showDatePicker = false
    @State private var sheetSize: PresentationDetent = .medium

    let alterKategorien = ["Jung", "Erwachsen", "Senior"]
    let altersangaben: [String: String] = [
        "Jung": "< 1 Jahr",
        "Erwachsen": "1 - 6 Jahre",
        "Senior": "> 6 Jahre"
    ]

    func berechnetesAlter(fuer datum: Date) -> String {
        let alter = Calendar.current.dateComponents([.year], from: datum, to: Date()).year ?? 0
        if alter < 1 {
            return "Jung"
        } else if alter <= 6 {
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
                                        tempGeburtsdatum = nil
                                        ausgewaehltesGeburtsdatum = nil
                                        ausgewaehltesAlter = ""
                                    }
                            } else {
                                Text("Nicht angegeben")
                                    .foregroundStyle(.gray)

                                Image(systemName: "circle")
                                    .onTapGesture {
                                        showDatePicker = true
                                        sheetSize = .large
                                    }
                            }
                        }

                        if showDatePicker {
                            VStack {
                                DatePicker(
                                    "Geburtsdatum wählen",
                                    selection: Binding(
                                        get: { tempGeburtsdatum ?? Date() },
                                        set: { tempGeburtsdatum = $0 }
                                    ),
                                    in: Calendar.current.date(byAdding: .year, value: -30, to: Date())!...Date(),
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.graphical)

                                Button("Fertig") {
                                    if let datum = tempGeburtsdatum {
                                        geburtsdatum = datum
                                        ausgewaehltesGeburtsdatum = datum
                                        ausgewaehltesAlter = berechnetesAlter(fuer: datum)
                                    }
                                    showDatePicker = false
                                    sheetSize = .medium
                                }
                                .padding()
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }

                    Section {
                        ForEach(alterKategorien, id: \.self) { alter in
                            HStack {
                                Text(alter)
                                    .foregroundStyle(.black)
                                Spacer()

                                if let altersangabe = altersangaben[alter] {
                                    Text(altersangabe)
                                        .foregroundStyle(.gray)
                                }

                                if alter == ausgewaehltesAlter {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else {
                                    Image(systemName: "circle")
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                ausgewaehltesAlter = alter
                                geburtsdatum = nil
                                tempGeburtsdatum = nil
                                ausgewaehltesGeburtsdatum = nil
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alter wählen")
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
                }
            }
            .presentationDetents([.medium, .large], selection: $sheetSize)
        }
    }
}





