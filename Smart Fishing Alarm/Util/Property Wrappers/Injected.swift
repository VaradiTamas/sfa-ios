//
//  Injected.swift
//  Smart Fishing Alarm
//
//  Created by Morvai Ákos on 2022. 12. 09..
//

import Foundation
import Swinject

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue: Dependency
    
    init() {
        self.wrappedValue = Injection.shared.container.resolve(Dependency.self)!
    }
}
