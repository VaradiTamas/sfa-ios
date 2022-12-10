//
//  BluetoothService.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 12. 09..
//

import Foundation
import RxSwift

protocol BluetoothService {
    var availableAlarmDevicesSubject: PublishSubject<[AlarmDevice]> { get }
    var connectedAlarmDevicesSubject: PublishSubject<[AlarmDevice]> { get }
    
    func startScanning()
    
    func stopScanning()
    
    func connectTo(alarmDevice: AlarmDevice)
}
