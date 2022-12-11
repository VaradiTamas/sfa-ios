//
//  BluetoothService.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 12. 09..
//

import CoreBluetooth
import Foundation
import RxSwift

protocol BluetoothService {
    var availableAlarmDevicesSubject: PublishSubject<[AlarmDevice]> { get }
    var connectedAlarmDevicesSubject: PublishSubject<[AlarmDevice]> { get }
    var alarmMessages: PublishSubject<AlarmMessage> { get }
    
    func startScanning()
    func stopScanning()
    func connectTo(alarmDevice: AlarmDevice)
    func writeOutgoing(message: String, to peripheral: CBPeripheral, with txCharacteristic: CBCharacteristic)
    func removeConnected(alarmDevice removableAlarmDevice: AlarmDevice)
}
