//
//  Inject.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 11.08.2024.
//

import Foundation
import SwiftUI

@propertyWrapper
struct Inject<Component> {
    var wrappedValue: Component
    init() {
        self.wrappedValue = ServiceLocator.Resolver.resolve(Component.self)!
    }
}

@propertyWrapper
struct InjectObservable<Service>: DynamicProperty where Service: ObservableObject {
    @ObservedObject private var service: Service
    
    init() {
        self.service = ServiceLocator.Resolver.resolve(Service.self)!
    }
    
    var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    
    public var projectedValue: ObservedObject<Service>.Wrapper {
        return self.$service
    }
}
