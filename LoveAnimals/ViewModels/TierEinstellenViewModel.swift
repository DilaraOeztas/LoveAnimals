//
//  TierEinstellenViewModel.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class TierEinstellenViewModel: ObservableObject {
    
    @Published var selectedImages: [UIImage] = []
    @Published var bilder: [String] = []
    @Published var imagePickerItems: [PhotosPickerItem] = []
    @Published var uploadedImageURLs: [String] = []
    @Published var tierheimID: String = ""
    @Published var tierName = ""
    @Published var tierBeschreibung = ""
    @Published var schutzgebuehr = ""
    @Published var ausgewaehlteTierart = ""
    @Published var benutzerdefinierteTierart: String = ""
    @Published var benutzerdefinierteRasse: [String: [String]] = [:]
    @Published var ausgewaehlteRasse = ""
    @Published var ausgewaehltesAlter = ""
    @Published var ausgewaehltesGeburtsdatum: Date? = nil
    @Published var ausgewaehlteGroesse = ""
    @Published var ausgewaehltesGeschlecht = ""
    @Published var ausgewaehlteFarbe = ""
    @Published var ausgewaehlteGesundheit = ""
    @Published var tierartIstBenutzerdefiniert: Bool = false
    @Published var neueTierart: String = ""
    @Published var neueRasse: String = ""
    @Published var benutzerdefinierteTierarten: [String: [String]] = [:]
    @Published var aktuelleRassen: [String] = []
    @Published var benutzerdefinierteFarben: [String] = []
    @Published var gespeicherteFarbe: String = ""
    @Published var neueFarbe: String = ""
    @Published var showTierartSheet = false
    @Published var showRassenSheet = false
    @Published var showGroesseSheet = false
    @Published var showGeschlechtSheet = false
    @Published var showAlterSheet = false
    @Published var showFarbenSheet = false
    @Published var showGesundheitSheet = false
    @Published var tierID: String = ""
    @Published var isUploading = false
    
    init() {
        Task {
            await ladeBenutzerdefinierteTierarten()
        }
    }
    
    func ladeTierDaten(_ animal: Animal) {
        self.tierID = animal.id ?? ""
        self.tierName = animal.name
        self.ausgewaehlteTierart = animal.tierart
        self.ausgewaehlteRasse = animal.rasse
        self.ausgewaehlteFarbe = animal.farbe
        self.ausgewaehltesAlter = animal.alter
        self.ausgewaehlteGroesse = animal.groesse
        self.ausgewaehlteGesundheit = animal.gesundheit
        self.ausgewaehltesGeschlecht = animal.geschlecht
        self.ausgewaehltesGeburtsdatum = animal.geburtsdatum
        self.schutzgebuehr = animal.schutzgebuehr
        self.tierBeschreibung = animal.beschreibung
        self.tierheimID = animal.tierheimID
        
        self.uploadedImageURLs = animal.bilder
        
        self.selectedImages = []
        Task {
            for urlString in animal.bilder {
                if let url = URL(string: urlString) {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.selectedImages.append(image)
                            }
                        }
                    } catch {
                        print("Fehler beim Laden des Bildes: \(error.localizedDescription) ")
                    }
                }
            }
        }
    }
    
    
    
    func loadImages(from items: [PhotosPickerItem]) {
        Task {
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    if selectedImages.count < 6 {
                        selectedImages.append(image)
                    }
                }
            }
            imagePickerItems.removeAll()
        }
    }
    
    func uploadAllImagesAndSave() async {
        isUploading = true
        uploadedImageURLs.removeAll()
        
        print("Starte Upload von \(selectedImages.count) Bildern...")
        
        for (index, image) in selectedImages.enumerated() {
            do {
                let url = try await ImgurService.uploadImage(image)
                uploadedImageURLs.append(url)
                print("Bild \(index + 1) erfolgreich hochgeladen: \(url)")
            } catch {
                print("Fehler beim Hochladen von Bild \(index + 1): \(error.localizedDescription)")
            }
        }
        print("Upload abgeschlossen: \(uploadedImageURLs.count) von \(selectedImages.count) Bildern erfolgreich.")
        if uploadedImageURLs.isEmpty {
            uploadedImageURLs = []
            print("Keine Bilder erfolgreich hochgeladen - Abbruch.")
        }
        if !tierID.isEmpty {
            await aktualisiereTierInFirestore()
        } else {
            await speichereTierInFirestore(bildUrls: uploadedImageURLs)
        }
        resetForm()
        isUploading = false
    }
    
    private func speichereTierInFirestore(bildUrls: [String]) async {
        guard let tierheimID = Auth.auth().currentUser?.uid else {
            print("Kein eingeloggtes Tierheim gefunden")
            return
        }
        let db = Firestore.firestore()
        let tierRef = db.collection("tierheime").document(tierheimID).collection("Tiere").document()

        var tierDaten: [String: Any] = [
            "name": tierName,
            "beschreibung": tierBeschreibung,
            "schutzgebuehr": schutzgebuehr,
            "tierart": neueTierart.isEmpty ? ausgewaehlteTierart : neueTierart,
            "rasse": neueRasse.isEmpty ? ausgewaehlteRasse : neueRasse,
            "alter": ausgewaehltesAlter,
            "geburtsdatum": ausgewaehltesGeburtsdatum != nil ? Timestamp(date: ausgewaehltesGeburtsdatum!) : NSNull(),
            "groesse": ausgewaehlteGroesse,
            "geschlecht": ausgewaehltesGeschlecht,
            "farbe": ausgewaehlteFarbe,
            "gesundheit": ausgewaehlteGesundheit,
            "bilder": bildUrls,
            "erstelltAm": Timestamp(date: Date()),
            "tierheimID": tierheimID
        ]
        if let geburtsdatum = ausgewaehltesGeburtsdatum {
            tierDaten["geburtsdatum"] = Timestamp(date: geburtsdatum)
        }
        do {
            try await tierRef.setData(tierDaten)
            print("Tier erfolgreich gespeichert!")
            if !neueTierart.isEmpty || !neueRasse.isEmpty {
                await speichereBenutzerdefinierteTierart(neueTierart: neueTierart, neueRasse: neueRasse)
            }
            resetForm()
        } catch {
            print("Fehler beim Speichern: \(error.localizedDescription)")
        }
    }
    
    func aktualisiereTierInFirestore() async {
        guard let tierheimID = Auth.auth().currentUser?.uid, !tierID.isEmpty else {
            print("Fehler: Keine gültige `tierID` oder kein eingeloggtes Tierheim gefunden")
            return
        }
        
        let db = Firestore.firestore()
        let tierRef = db.collection("tierheime").document(tierheimID).collection("Tiere").document(tierID)
        
        let neueBilder = !uploadedImageURLs.isEmpty ? uploadedImageURLs : []
        
        let tierDaten: [String: Any] = [
            "name": tierName,
            "tierart": ausgewaehlteTierart,
            "rasse": ausgewaehlteRasse,
            "alter": ausgewaehltesAlter,
            "geburtsdatum": ausgewaehltesGeburtsdatum.map { Timestamp(date: $0) } ?? NSNull(),
            "groesse": ausgewaehlteGroesse,
            "geschlecht": ausgewaehltesGeschlecht,
            "farbe": ausgewaehlteFarbe,
            "gesundheit": ausgewaehlteGesundheit,
            "beschreibung": tierBeschreibung,
            "schutzgebuehr": schutzgebuehr,
            "bilder": neueBilder,
            "tierheimID": tierheimID
        ]
        
        do {
            try await tierRef.setData(tierDaten, merge: true)
            print("Tier erfolgreich aktualisiert! (\(tierRef.documentID))")
        } catch {
            print("Fehler beim Aktualisieren: \(error.localizedDescription)")
        }
        
    }
    
    func addImage(_ image: UIImage) {
        if self.selectedImages.count < 6 {
            self.selectedImages.append(image)
        }
        
    }
    
    func loadImagesFromPicker() {
        Task {
            for item in imagePickerItems {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    addImage(image)
                }
            }
            imagePickerItems.removeAll()
        }
    }
    
    func resetForm() {
        self.selectedImages.removeAll()
        self.imagePickerItems.removeAll()
        self.uploadedImageURLs.removeAll()
        
        self.tierName = ""
        self.tierBeschreibung = ""
        self.schutzgebuehr = ""
        self.ausgewaehlteTierart = ""
        self.ausgewaehlteRasse = ""
        self.ausgewaehltesAlter = ""
        self.ausgewaehltesGeburtsdatum = nil
        self.ausgewaehlteGroesse = ""
        self.ausgewaehltesGeschlecht = ""
        self.ausgewaehlteFarbe = ""
        self.ausgewaehlteGesundheit = ""
        
    }
    

    func ladeRassenFuerTierart(tierart: String) async {
        guard let tierheimID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let tierheimRef = db.collection("tierheime").document(tierheimID)

        DispatchQueue.main.async {
            if let tierartEnum = Tierart(rawValue: tierart) {
                self.aktuelleRassen = tierartEnum.rassen()
            } else {
                self.aktuelleRassen = []
            }
        }
        do {
            let document = try await tierheimRef.getDocument()
            if let gespeicherteRassen = document.data()?["benutzerdefinierteTierarten"] as? [String: [String]] {
                if let rassenListe = gespeicherteRassen[tierart] {
                    DispatchQueue.main.async {
                        let gefilterteRassen = rassenListe.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                        self.aktuelleRassen.append(contentsOf: gefilterteRassen)
                        self.aktuelleRassen = Array(Set(self.aktuelleRassen))
                    }
                    print("Rassen erfolgreich geladen: \(self.aktuelleRassen)")
                } else {
                    print("Keine zusätzlichen Rassen für Tierart \(tierart) gefunden")
                }
            }
        } catch {
            print("Fehler beim Laden der Rassen: \(error.localizedDescription)")
        }
    }
    
    func speichereBenutzerdefinierteTierart(neueTierart: String, neueRasse: String) async {
        guard let tierheimID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let tierheimRef = db.collection("tierheime").document(tierheimID)

        if neueTierart.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || neueRasse.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("Fehler: Leere Tierart oder Rasse wird nicht gespeichert!")
            return
        }
        do {
            let document = try await tierheimRef.getDocument()
            var gespeicherteTierarten = document.data()?["benutzerdefinierteTierarten"] as? [String: [String]] ?? [:]

            if let tierartEnum = Tierart(rawValue: neueTierart), tierartEnum.rassen().contains(neueRasse) {
                print("Rasse bereits vordefiniert, wird nicht gespeichert.")
                return
            }

            if gespeicherteTierarten[neueTierart] == nil {
                gespeicherteTierarten[neueTierart] = []
            }
            
            if !neueRasse.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !gespeicherteTierarten[neueTierart]!.contains(neueRasse) {
                gespeicherteTierarten[neueTierart]!.append(neueRasse)
            }

            let firestoreData: [String: Any] = ["benutzerdefinierteTierarten": gespeicherteTierarten]
            try await tierheimRef.updateData(firestoreData)

            DispatchQueue.main.async {
                self.aktuelleRassen.append(neueRasse)
                self.aktuelleRassen = Array(Set(self.aktuelleRassen))
                self.aktuelleRassen = gespeicherteTierarten[neueTierart] ?? []
            }
            
            print("Neue Rasse gespeichert: \(neueRasse)")
        } catch {
            print("Fehler beim Speichern der Tierart/Rasse: \(error.localizedDescription)")
        }
    }
    
    
    func speichereBenutzerdefinierteFarben(farbe: String) async {
        guard let tierheimID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let tierheimRef = db.collection("tierheime").document(tierheimID)

        do {
            let document = try await tierheimRef.getDocument()
            var gespeicherteFarben = document.data()?["benutzerdefinierteFarben"] as? [String] ?? []

            let standardFarben = ["Schwarz", "Weiß", "Braun", "Grau", "Mehrfarbig"]

            if standardFarben.contains(farbe) {
                print("Farbe bereits vordefiniert, wird nicht gespeichert.")
                return
            }

            if !gespeicherteFarben.contains(farbe.trimmingCharacters(in: .whitespacesAndNewlines)), !farbe.isEmpty {
                gespeicherteFarben.append(farbe)
            }

            let farbenData: [String: Any] = ["benutzerdefinierteFarben": gespeicherteFarben]
            try await tierheimRef.updateData(farbenData)
            
            DispatchQueue.main.async {
                self.benutzerdefinierteFarben = gespeicherteFarben
            }
            
            print("Farbe erfolgreich gespeichert: \(farbe)")
        } catch {
            print("Fehler beim Speichern der Farbe: \(error.localizedDescription)")
        }
    }
    
    
    func ladeBenutzerdefinierteTierarten() async {
        guard let tierheimID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let tierheimRef = db.collection("tierheime").document(tierheimID)
        
        do {
            let document = try await tierheimRef.getDocument()
            if let gespeicherteTierarten = document.data()?["benutzerdefinierteTierarten"] as? [String: [String]] {
                DispatchQueue.main.async {
                    self.benutzerdefinierteTierarten = gespeicherteTierarten
                }
                print("Benutzerdefinierte Tierarten erfolgreich geladen: \(gespeicherteTierarten)")
            }
        } catch {
            print("Fehler beim Laden der Tierarten: \(error.localizedDescription)")
        }
    }
    
    
    func ladeBenutzerdefinierteFarben() async {
        guard let tierheimID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let tierheimRef = db.collection("tierheime").document(tierheimID)
        
        do {
            let document = try await tierheimRef.getDocument()
            if let gespeicherteFarben = document.data()?["benutzerdefinierteFarben"] as? [String] {
                DispatchQueue.main.async {
                    self.benutzerdefinierteFarben = Array(Set(gespeicherteFarben))
                }
                print("Benutzerdefinierte Farben erfolgreich geladen: \(gespeicherteFarben)")
            } else {
                DispatchQueue.main.async {
                    self.benutzerdefinierteFarben = []
                }
                print("Keine benutzerdefinierten Farben gefunden")
            }
        } catch {
            print("Fehler beim Laden der Farben aus Firestore: \(error.localizedDescription)")
        }
    }
}










