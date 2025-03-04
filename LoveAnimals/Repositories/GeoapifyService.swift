//
//  GeoapifyService.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

import Foundation

struct GeoapifyResponse: Codable {
    struct Feature: Codable {
        struct Geometry: Codable {
            let coordinates: [Double]
        }
        let geometry: Geometry
    }
    let features: [Feature]
}

final class GeoapifyService {

    static let shared = GeoapifyService()

    private let apiKey = "03af74ff6d7b467ea12e1c86c2472a5b"
    private let baseURL = "https://api.geoapify.com/v1/geocode/search?text=https://api.geoapify.com/v1/geocode/search?PLZ%26lang=de%26limit=1%26type=postcode%26filter=countrycode:de%26apiKey=&format=json&apiKey=03af74ff6d7b467ea12e1c86c2472a5b"

    private init() {}

    func fetchCoordinates(for postalCode: String, completion: @escaping (Double?, Double?) -> Void) {
        let query = [
            "text": postalCode,
            "lang": "de",
            "limit": "1",
            "type": "postcode",
            "filter": "countrycode:de",
            "apiKey": apiKey
        ]

        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            print("Fehler beim Erstellen der URL")
            completion(nil, nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fehler bei der Anfrage: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }

            guard let data = data else {
                print("Keine Daten erhalten")
                completion(nil, nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(GeoapifyResponse.self, from: data)

                if let firstFeature = result.features.first {
                    let latitude = firstFeature.geometry.coordinates[1]
                    let longitude = firstFeature.geometry.coordinates[0]
                    
                    completion(latitude, longitude)
                } else {
                    print("Keine Koordinaten gefunden")
                    completion(nil, nil)
                }
            } catch {
                print("Fehler beim Decodieren: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }.resume()
    }
}
