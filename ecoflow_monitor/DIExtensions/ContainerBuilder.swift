//
//  ContainerBuilder.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 11.08.2024.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import ecoflow_monitor_Data
import ecoflow_monitor_Domain
import ecoflow_monitor_API
import ecoflow_monitor_Mock

func runtimeContainerBuilder() -> Container {
    let container = Container()
    
    //load mock DAOs if in Previews
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        registerMock(container: container)
    }
    else{
        registerProd(container: container)
    }
    
    container.autoregister(EcoflowDevicesContext.self, initializer: EcoflowDevicesContext.init)
    
    return container
}

func registerMock(container: Container) {
    container.autoregister(EcoflowAuthDAO.self, initializer: EcoflowMockDAO.init)
        .implements(EcoflowDeviceDAO.self)
    container.autoregister(MQTTConnector.self, initializer: MockMQTTConnector.init)
    
    container.register(EcoflowAuthContext.self) { resolver in
        var flag = false
        let context = EcoflowAuthContext(authDAO: resolver.resolve(EcoflowAuthDAO.self)!)
        context.getMQTTAuthData(email: "", password: "", onSuccess: { flag = true }, onError: { _ in })
        
        while !flag { }
        return context
    }
    .inObjectScope(ObjectScope.container)
}

func registerProd(container: Container) {
    container.autoregister(EcoflowAuthDAO.self, initializer: EcoflowAPIDAO.init)
        .implements(EcoflowDeviceDAO.self)
    
    container.autoregister(MQTTConnector.self, initializer: EcoflowMQTTConnector.init).inObjectScope(ObjectScope.container)
    container.autoregister(EcoflowAuthContext.self, initializer: EcoflowAuthContext.init).inObjectScope(ObjectScope.container)
}
