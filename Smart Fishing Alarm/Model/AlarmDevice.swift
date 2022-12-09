//
//  BluetoothDevice.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 11. 24..
//

import CoreBluetooth
import Foundation

struct AlarmDevice {
    let name: String
    let rssi: Int
    let peripheral: CBPeripheral
    var rxCharacteristics: CBCharacteristic? = nil
    var txCharacteristics: CBCharacteristic? = nil
}
