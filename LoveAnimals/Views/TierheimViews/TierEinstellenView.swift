//
//  TierEinstellenView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct TierEinstellenView: View {
    @State private var bilder: [UIImage] = []
    @State private var showingPhotoPicker = false
    @State private var showingCameraPicker = false
    @State private var showingPhotoSourceAlert = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showMaxBilderAlert = false
    @State private var showAbbrechenAlert = false
    @Binding var selectedTab: Int
    @State private var ausgewählteTierart: String = ""
    @State private var ausgewählteRasse = ""
    @State private var ausgewähltenGroesse = ""
    @State private var ausgewähltesGeschlecht = ""
    @State private var ausgewähltesAlter = ""
    @State private var ausgewählteFarbe = ""
    @State private var ausgewählteGesundheit = ""
    
    @State private var showTierartSheet = false
    @State private var showRassenSheet = false
    @State private var aktuelleRassen: [String] = []
    @State private var showGroesseSheet = false
    @State private var showGeschlechtSheet = false
    @State private var showAlterSheet = false
    @State private var showFarbenSheet = false
    @State private var showGesundheitSheet = false
    @State private var beschreibung: String = ""
    @State private var schutzgebuehr: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .cornerRadius(12)
                            .overlay {
                                if bilder.isEmpty {
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 60, weight: .light))
                                        .foregroundStyle(.gray)
                                } else {
                                    Image(uiImage: bilder.first!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                }
                            }
                            .onTapGesture {
                                showingPhotoSourceAlert = true
                            }
                    }
                    .padding(.bottom, 10)
                    
                    if bilder.count >= 1 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(bilder.dropFirst().enumerated()), id: \.offset) { index, image in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 60)
                                            .clipped()
                                            .cornerRadius(8)
                                        
                                        Button {
                                            bilder.remove(at: index + 1)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.white, .gray)
                                        }
                                        .offset(x: 1, y: -1)
                                    }
                                }
                                Button {
                                    if bilder.count >= 6 {
                                        showMaxBilderAlert = true
                                        
                                    } else {
                                        showingPhotoSourceAlert = true
                                    }
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5]))
                                            .frame(width: 80, height: 60)
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 30))
                                            .frame(width: 80, height: 60)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                    
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    
                    
                    TierOptionView(title: "Tierart", value: ausgewählteTierart) {
                        showTierartSheet = true
                    }
                    TierOptionView(title: "Rasse", value: ausgewählteRasse) {
                        if let tierart = Tierart(rawValue: ausgewählteTierart) {
                            aktuelleRassen = tierart.rassen()
                            showRassenSheet = true
                        }
                    }
                    TierOptionView(title: "Alter", value: ausgewähltesAlter) {
                        showAlterSheet = true
                    }
                    TierOptionView(title: "Größe", value: ausgewähltenGroesse) {
                        showGroesseSheet = true
                    }
                    TierOptionView(title: "Geschlecht", value: ausgewähltesGeschlecht) {
                        showGeschlechtSheet = true
                    }
                    TierOptionView(title: "Farbe", value: ausgewählteFarbe) {
                        showFarbenSheet = true
                    }
                    TierOptionView(title: "Gesundheitszustand", value: ausgewählteGesundheit) {
                        showGesundheitSheet = true
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Beschreibung")
                            .font(.headline)
                            .foregroundStyle(.black)

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $beschreibung)
                                .frame(minHeight: 120, maxHeight: 150)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            if beschreibung.isEmpty {
                                Text("Geben Sie hier eine Beschreibung zum Tier ein (z. B. Charakter, Besonderheiten)...")
                                    .foregroundStyle(.gray.opacity(0.5))
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Schutzgebühr (€)")
                            .font(.headline)
                            .foregroundStyle(.black)

                        TextField("z.B. 150", text: $schutzgebuehr)
                            .keyboardType(.numberPad)
                            .padding()
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .onChange(of: schutzgebuehr) { _, newValue in
                                schutzgebuehr = newValue.filter { $0.isNumber }
                            }
                    }
                }
                .navigationTitle("Tier einstellen")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Abbrechen") {
                            showAbbrechenAlert = true
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .alert("Bildquelle auswählen", isPresented: $showingPhotoSourceAlert) {
            Button("Kamera") { checkCameraPermission() }
            Button("Galerie") { checkPhotoLibraryPermission() }
            Button("Abbrechen", role: .cancel) {}
        }
        .alert("Maximale Anzahl erreicht", isPresented: $showMaxBilderAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Du kannst maximal 6 Bilder hochladen.")
        }
        .alert("Hinweis", isPresented: $showAbbrechenAlert) {
            Button("Abbrechen", role: .destructive) {
                selectedTab = 0
            }
            Button("Fortfahren", role: .cancel) { }
        } message: {
            Text("Wenn du abbrichst, gehen alle Eingaben verloren. Möchtest du wirklich abbrechen?")
        }
        .sheet(isPresented: $showingPhotoPicker) {
            ImagePicker(images: $bilder, maxImages: 6)
        }
        .sheet(isPresented: $showingCameraPicker) {
            CameraPicker(image: $bilder)
        }
        .sheet(isPresented: $showTierartSheet) {
            TierartSheet(ausgewählteTierart: $ausgewählteTierart, showTierartSheet: $showTierartSheet)
        }
        .sheet(isPresented: $showRassenSheet) {
            RassenSheet(rassen: aktuelleRassen, ausgewählteRasse: $ausgewählteRasse)
        }
        .sheet(isPresented: $showAlterSheet) {
            AlterSheet(ausgewählteAlter: $ausgewähltesAlter, showAlterSheet: $showAlterSheet)
        }
        .sheet(isPresented: $showGroesseSheet) {
            GroessenSheet(ausgewählteGröße: $ausgewähltenGroesse, showGroessenSheet: $showGroesseSheet)
        }
        .sheet(isPresented: $showGeschlechtSheet) {
            GeschlechtSheet(ausgewähltesGeschlecht: $ausgewähltesGeschlecht, showSheet: $showGeschlechtSheet)
        }
        .sheet(isPresented: $showFarbenSheet) {
            FarbenSheet(ausgewählteFarbe: $ausgewählteFarbe, showFarbenSheet: $showFarbenSheet)
        }
        .sheet(isPresented: $showGesundheitSheet) {
            Gesundheitszustand(ausgewählteGesundheit: $ausgewählteGesundheit, showGesundheitSheet: $showGesundheitSheet)
        }
        
    }
    
    
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        if bilder.count >= 6 {
            showMaxBilderAlert = true
            return
        }
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    sourceType = .photoLibrary
                    showingPhotoPicker = true
                }
            }
        case .authorized:
            sourceType = .photoLibrary
            showingPhotoPicker = true
        case .denied, .restricted, .limited:
            print("Kein Zugriff auf die Fotobibliothek erlaubt.")
        @unknown default:
            break
        }
    }
    
    func checkCameraPermission() {
        if bilder.count >= 6 {
            showMaxBilderAlert = true
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    sourceType = .camera
                    showingCameraPicker = true
                }
            }
        case .authorized:
            sourceType = .camera
            showingCameraPicker = true
        case .denied, .restricted:
            print("Kein Zugriff auf die Kamera")
        @unknown default:
            break
        }
    }
}


#Preview {
    TierEinstellenView(selectedTab: .constant(1))
}
