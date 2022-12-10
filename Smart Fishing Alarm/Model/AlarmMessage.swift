//
//  DeviceMessage.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 12. 10..
//

import Foundation
import CoreBluetooth

struct AlarmMessage {
    let peripheral: CBPeripheral
    let message: String
}
