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
    @Published var imagePickerItems: [PhotosPickerItem] = []
    @Published var uploadedImageURLs: [String] = []
    
    @Published var tierName = ""
    @Published var tierBeschreibung = ""
    @Published var schutzgebuehr = ""
    @Published var ausgewaehlteTierart = ""
    @Published var ausgewaehlteRasse = ""
    @Published var ausgewaehltesAlter = ""
    @Published var ausgewaehltesGeburtsdatum: Date? = nil
    @Published var ausgewaehlteGroesse = ""
    @Published var ausgewaehltesGeschlecht = ""
    @Published var ausgewaehlteFarbe = ""
    @Published var ausgewaehlteGesundheit = ""
    
    
    @Published var showTierartSheet = false
    @Published var showRassenSheet = false
    @Published var aktuelleRassen: [String] = []
    @Published var showGroesseSheet = false
    @Published var showGeschlechtSheet = false
    @Published var showAlterSheet = false
    @Published var showFarbenSheet = false
    @Published var showGesundheitSheet = false
    
    @Published var isUploading = false
    
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
            print("Keine Bilder erfolgreich hochgeladen - Abbruch.")
            isUploading = false
            return
        }

        await speichereTierInFirestore(bildUrls: uploadedImageURLs)

        resetForm()
        isUploading = false
    }
    
    private func speichereTierInFirestore(bildUrls: [String]) async {
        guard let tierheimID = Auth.auth().currentUser?.uid else {
            print("Kein eingeloggtes Tierheim gefunden")
            return
        }
        
        let tierDaten: [String: Any] = [
            "name": tierName,
            "beschreibung": tierBeschreibung,
            "schutzgebuehr": schutzgebuehr,
            "tierart": ausgewaehlteTierart,
            "rasse": ausgewaehlteRasse,
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
        
        let db = Firestore.firestore()
        do {
            let tierRef = db.collection("tierheime").document(tierheimID).collection("Tiere").document()
            try await tierRef.setData(tierDaten)
            print("Tier erfolgreich gespeichert!")
        } catch {
            print("Fehler beim Speichern: \(error.localizedDescription)")
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
}
