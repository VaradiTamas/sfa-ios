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
    
    public let connectedAlarmDevicesSubject = PublishSubject<[AlarmDevice]>()

    let disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    func setupBindings() {
        bluetoothService.connectedAlarmDevicesSubject
            .bind(to: self.connectedAlarmDevicesSubject)
            .disposed(by: disposeBag)
    }
}
