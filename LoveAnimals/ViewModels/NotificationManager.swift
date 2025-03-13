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
    
    
    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "LoveAnimals Erinnerung"
        content.body = "Vergiss nicht, neue Tiere zu entdecken!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Fehler beim Planen der täglichen Benachrichtigung: \(error.localizedDescription)")
            } else {
                print("Tägliche Benachrichtigung geplant ✅")
            }
        }
    }
}

