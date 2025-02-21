//
//  NotificationManager.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 21.02.25.
//

import UserNotifications
import UIKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Fehler beim Anfordern der Berechtigung: \(error.localizedDescription)")
            } else {
                print("Benachrichtigungen erlaubt: \(granted)")
            }
        }
        center.delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    
}

