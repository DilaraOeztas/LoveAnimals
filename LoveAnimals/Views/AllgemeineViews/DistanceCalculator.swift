//
//  DistanceCalculator.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 03.03.25.
//

import Foundation
import CoreLocation

struct DistanceCalculator {
    static func calculateDistance(from userLocation: (latitude: Double, longitude: Double), toPLZ plz: String) -> Double {
        guard let targetCoordinates = PLZKoordinatenService.shared.getCoordinates(for: plz) else {
            return 0.0
        }

        let userLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let targetLocation = CLLocation(latitude: targetCoordinates.latitude, longitude: targetCoordinates.longitude)

        let distanceInMeters = userLocation.distance(from: targetLocation)
        let distanceInKilometers = distanceInMeters / 1000.0
        return distanceInKilometers
    }
}
