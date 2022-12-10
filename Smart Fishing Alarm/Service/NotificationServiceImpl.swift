//
//  NotificationServiceImpl.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 12. 10..
//

import Foundation
import UIKit
import UserNotifications

class NotificationServiceImpl: NotificationService {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification(for alarmMessage: AlarmMessage) {
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = alarmMessage.peripheral.name ?? "Unknown alarm"
            content.subtitle = "Value recieved: \(alarmMessage.message)"
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: alarmMessage.peripheral.identifier.uuidString, content: content, trigger: nil)
            
            center.add(request)
        }
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                // notifications are turned off :(
            }
        }
    }
}
