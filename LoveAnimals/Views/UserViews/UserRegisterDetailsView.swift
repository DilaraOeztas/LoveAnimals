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
    @EnvironmentObject var authViewModel: UserAuthViewModel
    @EnvironmentObject var tierheimAuthViewModel: TierheimAuthViewModel
    
    @State private var showProfessionOptions = false
    @State private var showHousingOptions = false
    @State private var showFamilyOptions = false
    @State private var showSkipAlert = false
    @State private var navigateToHome: Bool = false
    
    var firstName: String
    var lastName: String
    var birthdate: Date
    var email: String
    var postalCode: String
    var city: String
    var password: String
    
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
        "Geschieden",
        "Sonstiges"
    ]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Erzähle uns mehr über dich")
                        .font(.title)
                        .bold()
                        .padding(.top, 10)
                    
                    dropdownSection(
                        title: "Beruf",
                        selectedOption: $authViewModel.selectedProfession,
                        showOptions: $showProfessionOptions,
                        options: professionOptions)
                    
                    dropdownSection(
                        title: "Wohnsituation",
                        selectedOption: $authViewModel.selectedHousing,
                        showOptions: $showHousingOptions,
                        options: housingOptions)
                    
                    Toggle("Haben Sie einen Garten?", isOn: $authViewModel.hasGarden)
                        .padding(.horizontal)
                    
                    dropdownSection(
                        title: "Familienstand",
                        selectedOption: $authViewModel.selectedFamily,
                        showOptions: $showFamilyOptions,
                        options: familyOptions)
                    
                    Toggle("Haben Sie Kinder?", isOn: $authViewModel.hasChildren)
                        .padding(.horizontal)
                    
                    
                    if authViewModel.hasChildren {
                        VStack(alignment: .leading) {
                            Text("Wie viele Kinder haben Sie?")
                                .font(.headline)
                                .foregroundStyle(.gray)
                            
                            TextField("Anzahl der Kinder", text: $authViewModel.numberOfChildren)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled(true)
                                .keyboardType(.numberPad)
                                .padding(.top, 5)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Wie alt sind Ihre Kinder?")
                                .font(.headline)
                                .foregroundStyle(.gray)
                            
                            TextField("Alter der Kinder (z.B.: 3, 5, 8)", text: $authViewModel.childrenAges)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled(true)
                                .keyboardType(.numbersAndPunctuation)
                                .padding(.top, 5)
                        }
                        .padding(.horizontal)
                    }
                    
                    Toggle("Haben Sie Haustiere?", isOn: $authViewModel.hasPets)
                        .padding(.horizontal)

                        if authViewModel.hasPets {
                            VStack(alignment: .leading) {
                                Text("Welche Haustiere haben Sie?")
                                    .font(.headline)
                                    .foregroundStyle(.gray)

                                TextField("z.B. Hund, Katze, Hamster", text: $authViewModel.petTypes)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocorrectionDisabled(true)
                                    .padding(.top, 5)

                                Text("Wie viele Haustiere haben Sie?")
                                    .font(.headline)
                                    .foregroundStyle(.gray)

                                TextField("Anzahl", text: $authViewModel.numberOfPets)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .padding(.top, 5)

                                Text("Wie alt sind Ihre Haustiere?")
                                    .font(.headline)
                                    .foregroundStyle(.gray)

                                TextField("Alter der Haustiere (z.B. 2, 5, 8)", text: $authViewModel.petAges)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocorrectionDisabled(true)
                                    .keyboardType(.numbersAndPunctuation)
                                    .padding(.top, 5)
                            }
                            .padding(.horizontal)
                        }
                    
                    Button(action: {
                        Task {
                            await authViewModel.register(
                                firstName: firstName,
                                lastName: lastName,
                                email: email,
                                password: password,
                                postalCode: postalCode,
                                city: city,
                                birthdate: birthdate,
                                signedUpOn: Date()
                            )
                            await authViewModel.saveUserDetails(isSkipped: false)
                            navigateToHome = true
                        }
                    }) {
                        Text("Speichern & Weiter")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.brown)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                    
                    
                    Button(action: {
                        showSkipAlert = true
                    }) {
                        Text("Überspringen")
                            .font(.headline)
                            .foregroundStyle(.gray)
                            .underline()
                    }
                    .alert(isPresented: $showSkipAlert) {
                        Alert(
                            title: Text("Möchtest du wirklich überspringen?"),
                            // swiftlint:disable:next line_length
                            message: Text("Diese Angaben sind für eine erfolgreiche Adoption wichtig. Du kannst sie später in den Profileinstellungen ergänzen."),
                            primaryButton: .destructive(Text("Überspringen")) {
                                Task {
                                    await authViewModel.register(
                                        firstName: firstName,
                                        lastName: lastName,
                                        email: email,
                                        password: password,
                                        postalCode: postalCode,
                                        city: city,
                                        birthdate: birthdate,
                                        signedUpOn: Date()
                                    )
                                    await authViewModel.saveUserDetails(isSkipped: true)
                                    navigateToHome = true
                                }
                            },
                            secondaryButton: .cancel(Text("Abbrechen"))
                        )
                    }
                    .padding(.bottom, 20)
                    
                }
                .navigationDestination(isPresented: $navigateToHome) {
                    UserHomeView2()
                }
                .navigationBarBackButtonHidden(true)
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            )
        }
    }
    
    
    
    @ViewBuilder
    func dropdownSection(title: String, selectedOption: Binding<String>, showOptions: Binding<Bool>, options: [String]) -> some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(selectedOption.wrappedValue.isEmpty ? title : selectedOption.wrappedValue)
                    .foregroundStyle(selectedOption.wrappedValue.isEmpty ? .gray : .black)
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
}



#Preview {
    UserRegisterDetailsView(firstName: "test", lastName: "test", birthdate: Date(), email: "test@test.com", postalCode: "33333", city: "test", password: "test12345")
        .environmentObject(UserAuthViewModel())
        .environmentObject(TierheimAuthViewModel())
}
