//
//  BluetoothService.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 12. 09..
//

import CoreBluetooth
import Foundation
import RxSwift

class BluetoothServiceImpl: NSObject, BluetoothService {
    private var centralManager: CBCentralManager!
    
    private var availableAlarmDevices = [AlarmDevice]() {
        didSet {
            availableAlarmDevicesSubject.onNext(availableAlarmDevices)
        }
    }
    private var connectedAlarmDevices = [AlarmDevice]() {
        didSet {
            connectedAlarmDevicesSubject.onNext(connectedAlarmDevices)
        }
    }
    
    let availableAlarmDevicesSubject = PublishSubject<[AlarmDevice]>()
    let connectedAlarmDevicesSubject = PublishSubject<[AlarmDevice]>()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        availableAlarmDevices = []
        
        centralManager.scanForPeripherals(withServices: [CBUUID(string: AppConstants.BLE_SERVICE_UUID)])
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func connectTo(alarmDevice: AlarmDevice) {
        if !connectedAlarmDevices.contains(where: { $0.peripheral.identifier == alarmDevice.peripheral.identifier }) {
            alarmDevice.peripheral.delegate = self
            centralManager.connect(alarmDevice.peripheral, options: nil)
        }
    }
}

extension BluetoothServiceImpl: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOff:
                print("Is Powered Off.")
            case .poweredOn:
                print("Is Powered On.")
                //                startScanning()
            case .unsupported:
                print("Is Unsupported.")
            case .unauthorized:
                print("Is Unauthorized.")
            case .unknown:
                print("Unknown")
            case .resetting:
                print("Resetting")
            @unknown default:
                print("Error")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral Discovered: \(peripheral)")
        print("Peripheral name: \(peripheral.name ?? "Unknown name")")
        print ("Advertisement Data : \(advertisementData)")
        print ("ID : \(peripheral.identifier)")
        
        if !availableAlarmDevices.contains(where: { $0.rssi == RSSI.intValue }) {
            availableAlarmDevices.append(
                AlarmDevice(name: peripheral.name ?? "Unknown name", rssi: RSSI.intValue, peripheral: peripheral))
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Didconnect: \(peripheral.identifier)")
        peripheral.delegate = self
        guard let alarmDevice = availableAlarmDevices.first(where: { $0.peripheral.identifier == peripheral.identifier }) else { return }
        connectedAlarmDevices.append(alarmDevice)
        peripheral.discoverServices(nil)
    }
}

extension BluetoothServiceImpl: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else {
            print("No services discovered for: \(peripheral.identifier)")
            return
        }
        //We need to discover the all characteristic
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            print("No characteristics for: \(peripheral.identifier)")
            return
        }
        guard var connectedAlarmDevice = connectedAlarmDevices.first(where: { $0.peripheral.identifier == peripheral.identifier }) else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) || characteristic.properties.contains(.notify) {
                //                connectedAlarmDevices.first(where: { $0.peripheral.identifier == peripheral.identifier })?.rxCharacteristics = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                connectedAlarmDevice.txCharacteristics = characteristic
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard connectedAlarmDevices.contains(where: { $0.peripheral.identifier == peripheral.identifier }),
              let characteristicValue = characteristic.value,
              let stringValue = String(data: characteristicValue, encoding: .utf8) else { return }
        
        print("Value Recieved: \(stringValue) from \(peripheral.identifier)")
    }
}

extension BluetoothServiceImpl: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
            case .poweredOn:
                print("Peripheral Is Powered On.")
            case .unsupported:
                print("Peripheral Is Unsupported.")
            case .unauthorized:
                print("Peripheral Is Unauthorized.")
            case .unknown:
                print("Peripheral Unknown")
            case .resetting:
                print("Peripheral Resetting")
            case .poweredOff:
                print("Peripheral Is Powered Off.")
            @unknown default:
                print("Error")
        }
    }
}
