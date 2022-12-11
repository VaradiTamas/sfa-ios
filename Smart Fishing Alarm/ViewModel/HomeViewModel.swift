//
//  HomeViewModel.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 11. 24..
//

import CoreBluetooth
import Foundation
import RxCocoa
import RxSwift

class ViewModel {
    @Injected private var bluetoothService: BluetoothService
    @Injected private var notificationService: NotificationService
    
    public let connectedAlarmDevicesSubject = PublishSubject<[AlarmDevice]>()

    let disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    func setupBindings() {
        bluetoothService.connectedAlarmDevicesSubject
            .bind(to: self.connectedAlarmDevicesSubject)
            .disposed(by: disposeBag)
        
        bluetoothService.alarmMessages
            .subscribe(onNext: { [weak self] alarmMessage in
                print("Message in viewmodel: \(alarmMessage.message)")
                self?.notificationService.scheduleNotification(for: alarmMessage)
            })
            .disposed(by: disposeBag)
    }
    
    func sendMessage(to alarmDevice: AlarmDevice, message: String) {
        guard let peripheral = alarmDevice.peripheral,
              let txCharacteristic = alarmDevice.txCharacteristics else { return }
        
        bluetoothService.writeOutgoing(message: message, to: peripheral, with: txCharacteristic)
    }
    
    func removeConnected(alarmDevice: AlarmDevice) {
        bluetoothService.removeConnected(alarmDevice: alarmDevice)
    }
}
