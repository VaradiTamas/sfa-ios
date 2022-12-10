//
//  BluetoothDevice.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 11. 24..
//

import CoreBluetooth
import Foundation

struct AlarmDevice: Codable {
    let name: String
    let rssi: Int
    let peripheralId: String
    
    var peripheral: CBPeripheral? = nil
    var rxCharacteristics: CBCharacteristic? = nil
    var txCharacteristics: CBCharacteristic? = nil
    
    private enum CodingKeys: CodingKey {
        case name
        case rssi
        case peripheralId
    }
}
