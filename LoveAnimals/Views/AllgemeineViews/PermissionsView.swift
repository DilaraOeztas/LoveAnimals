//
//  ThPermissionsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI
import CoreLocation

struct PermissionsView: View {
    @State private var locationStatus: CLAuthorizationStatus?

    var body: some View {
        VStack {
            Text("Standortberechtigungen")
                .font(.headline)
                .padding()
            
            Text(locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways
                 ? "Erlaubt"
                 : "Nicht erlaubt")
                .foregroundStyle(locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways ? .green : .red)
            
            Button("Zu den App-Einstellungen") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .padding()
        }
        .onAppear {
            checkLocationPermission()
        }
    }

    func checkLocationPermission() {
        let manager = CLLocationManager()
        locationStatus = manager.authorizationStatus
    }
}
