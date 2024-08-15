//
//  ServiceLocator.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 11.08.2024.
//

import Foundation
import Swinject

class ServiceLocator {
    private static var isContainerInitialized = false;
    private static var _containerInstance = Container();
    
    // update the retreived protocol to ensure it return non-nil values. If nill happens - throw
    public static var Resolver: Resolver{ get { return _containerInstance; }}

    public static func setIOCBuilder(_ containerBuilder: () -> Container) {
        if(self.isContainerInitialized) {
            return;
        } else {
            isContainerInitialized = true;
            self._containerInstance = containerBuilder();
        }
    }
}
