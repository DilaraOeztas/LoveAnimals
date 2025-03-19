//
//  PLZKoordinatenService.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

//import Foundation
//
//class PLZKoordinatenService {
//    static let shared = PLZKoordinatenService()
//
//    private var plzKoordinaten: [String: (latitude: Double, longitude: Double)] = [:]
//
//    private init() {
//        ladePLZKoordinaten()
//    }
//
//    private func ladePLZKoordinaten() {
//        if let url = Bundle.main.url(forResource: "PLZKoordinaten", withExtension: "json"),
//           let data = try? Data(contentsOf: url),
//           let decoded = try? JSONDecoder().decode([PLZKoordinatenEintrag].self, from: data) {
//            decoded.forEach { entry in
//                plzKoordinaten[entry.plz] = (entry.latitude, entry.longitude)
//            }
//        }
//    }
//
//    func getCoordinates(for plz: String) -> (latitude: Double, longitude: Double)? {
//        return plzKoordinaten[plz]
//    }
//}
//
//struct PLZKoordinatenEintrag: Codable {
//    let plz: String
//    let latitude: Double
//    let longitude: Double
//}
