//
//  NotificationService.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 12. 10..
//

import Foundation

protocol NotificationService {
    func scheduleNotification(for alarmMessage: AlarmMessage)
}
