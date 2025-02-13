//
//  UserDetailsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 12.02.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserRegisterDetailsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedProfession = "Beruf auswählen"
    @State private var selectedHousing = "Wohnsituation auswählen"
    @State private var hasGarden = false
    @State private var selectedFamily = "Familienstand auswählen"
    @State private var hasChildren = false
    @State private var numberOfChildren = ""
    @State private var childrenAges = ""

    @State private var showProfessionOptions = false
    @State private var showHousingOptions = false
    @State private var showFamilyOptions = false
    @State private var showSkipAlert = false

    let professionOptions = [
        "Student",
        "Angestellter",
        "Selbstständig",
        "Arbeiter",
        "Beamter",
        "Rentner",
        "Sonstiges"
    ]

    let housingOptions = [
        "Mietwohnung",
        "Eigentumswohnung",
        "Haus",
        "WG",
        "Sonstiges"
    ]

    let familyOptions = [
        "Single",
        "Verheiratet",
        "Sonstiges"
    ]


    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Erzähle uns mehr über dich")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)

                dropdownSection(
                    title: "Beruf",
                    selectedOption: $selectedProfession,
                    showOptions: $showProfessionOptions,
                    options: professionOptions)

                dropdownSection(
                    title: "Wohnsituation",
                    selectedOption: $selectedHousing,
                    showOptions: $showHousingOptions,
                    options: housingOptions)

                Toggle("Haben Sie einen Garten?", isOn: $hasGarden)
                    .padding(.horizontal)

                dropdownSection(
                    title: "Familienstand",
                    selectedOption: $selectedFamily,
                    showOptions: $showFamilyOptions,
                    options: familyOptions)

                Toggle("Haben Sie Kinder?", isOn: $hasChildren)
                    .padding(.horizontal)

                if hasChildren {
                    VStack(alignment: .leading) {
                        Text("Wie viele Kinder haben Sie?")
                            .font(.headline)
                            .foregroundColor(.gray)

                        TextField("Anzahl der Kinder", text: $numberOfChildren)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.top, 5)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text("Wie alt sind Ihre Kinder?")
                            .font(.headline)
                            .foregroundColor(.gray)

                        TextField("Alter der Kinder (z.B.: 3, 5, 8)", text: $childrenAges)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numbersAndPunctuation)
                            .padding(.top, 5)
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    authViewModel.navigateToHome = true
                }) {
                    Text("Speichern & Weiter")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.brown)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)

                Button(action: {
                    showSkipAlert = true
                }) {
                    Text("Überspringen")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .underline()
                }
                .alert(isPresented: $showSkipAlert) {
                    Alert(
                        title: Text("Möchtest du wirklich überspringen?"),
                        // swiftlint:disable:next line_length
                        message: Text("Diese Angaben sind für eine erfolgreiche Adoption wichtig. Du kannst sie später in den Profileinstellungen ergänzen."),
                        primaryButton: .destructive(Text("Überspringen")) {
                            authViewModel.navigateToHome = true
                        },
                        secondaryButton: .cancel(Text("Abbrechen"))
                    )
                }
                .padding(.bottom, 20)
                .navigationDestination(isPresented: $authViewModel.navigateToHome) {
                    HomeView()
                }
            }
        }
    }

    @ViewBuilder
    func dropdownSection(title: String, selectedOption: Binding<String>, showOptions: Binding<Bool>, options: [String]) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.gray)

            HStack {
                Text(selectedOption.wrappedValue)
                    .foregroundStyle(.black)
                Spacer()
                Button(action: { showOptions.wrappedValue.toggle() }) {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.gray)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)

            if showOptions.wrappedValue {
                VStack(spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        HStack {
                            Text(option)
                                .foregroundStyle(.black)
                            Spacer()
                            Button(action: {
                                selectedOption.wrappedValue = option
                                showOptions.wrappedValue = false
                            }) {
                                Image(
                                    systemName: selectedOption.wrappedValue == option ?
                                    "largecircle.fill.circle" : "circle"
                                )
                                    .foregroundStyle(
                                        selectedOption.wrappedValue == option ? .brown : .gray
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding(.horizontal)
    }

    func saveUserDetails() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Fehler: Kein eingeloggter User gefunden.")
            return
        }

        var userDetails: [String: Any] = [
            "userID": userID,
            "profession": selectedProfession,
            "housingSituation": selectedHousing,
            "hasGarden": hasGarden,
            "familyStatus": selectedFamily,
            "hasChildren": hasChildren,
            "updatedAt": Timestamp()
        ]

        if hasChildren {
            userDetails["numberOfChildren"] = numberOfChildren
            userDetails["childrenAges"] = childrenAges
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).setData(userDetails, merge: true) { error in
            if let error = error {
                print("Fehler beim Speichern der Daten: \(error.localizedDescription)")
            } else {
                print("Daten erfolgreich gespeichert!")
                authViewModel.navigateToHome = true
            }
        }
    }
}

#Preview {
    UserRegisterDetailsView()
        .environmentObject(AuthViewModel())
}
