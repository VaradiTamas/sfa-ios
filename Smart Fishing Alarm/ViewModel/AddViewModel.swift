//
//  AddViewModel.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2023. 01. 03..
//

import Foundation
import RxCocoa
import RxSwift

extension AddViewController {
    class ViewModel {
        @Injected private var bluetoothService: BluetoothService
        
        public let availableAlarmDevicesSubject = PublishSubject<[AlarmDevice]>()
        
        let disposeBag = DisposeBag()
        
        init() {
            setupBindings()
        }
        
        func setupBindings() {
            bluetoothService.availableAlarmDevicesSubject
                .bind(to: self.availableAlarmDevicesSubject)
                .disposed(by: disposeBag)
        }
        
        func connectTo(alarmDevice: AlarmDevice) {
            bluetoothService.connectTo(alarmDevice: alarmDevice)
        }
        
        func startScanning() {
            bluetoothService.startScanning()
        }
    }
}
