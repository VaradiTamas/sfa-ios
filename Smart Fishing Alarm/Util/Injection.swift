//
//  Injection.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 12. 09..
//

import Foundation
import Swinject

final class Injection {
    static let shared = Injection()
    var container: Container {
        get {
            if _container == nil {
                _container = buildContainer()
            }
            return _container!
        }
        set {
            _container = newValue
        }
    }
    
    private var _container: Container?
    
    private func buildContainer() -> Container {
        let container = Container()
        container.register(BluetoothService.self) { _ in
            return BluetoothServiceImpl()
        }
        .inObjectScope(.container)
        container.register(NotificationService.self) { _ in
            return NotificationServiceImpl()
        }
        
        return container
    }
}
